import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Owns the app's identity without a login screen.
///
/// Firebase Anonymous Auth gives each device a secure uid while keeping the app
/// accountless for users. If the Firebase project has not enabled Anonymous
/// Auth yet, the app falls back to a local id so startup does not fail; secure
/// Firestore user writes require Anonymous Auth to be enabled.
class SessionService extends GetxService {
  static SessionService get to => Get.find();

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  late String userId;
  bool usingAnonAuth = false;

  Future<SessionService> init() async {
    userId = await _resolveUserId();
    _bootstrapUserDoc();
    return this;
  }

  Future<String> _resolveUserId() async {
    // Prefer Firebase Anonymous Auth. On a cold start the first sign-in can be
    // slow (App Check attestation happens first), so we wait generously and,
    // if the call times out, still pick up the uid once auth settles — the
    // security rules require request.auth.uid to match the users/{uid} path,
    // so we must NOT fall back to a device id while anon auth is actually
    // succeeding in the background.
    try {
      var user = _auth.currentUser;
      if (user == null) {
        user = (await _auth.signInAnonymously().timeout(
          const Duration(seconds: 25),
        )).user;
      }
      user ??= _auth.currentUser;
      if (user != null) {
        usingAnonAuth = true;
        return user.uid;
      }
    } catch (e) {
      debugPrint('Anonymous Firebase auth slow/failed, waiting for auth state: $e');
      try {
        final user = _auth.currentUser ??
            await _auth
                .authStateChanges()
                .firstWhere((u) => u != null)
                .timeout(const Duration(seconds: 15));
        if (user != null) {
          usingAnonAuth = true;
          return user.uid;
        }
      } catch (e2) {
        debugPrint('Anonymous auth did not settle: $e2');
      }
    }

    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('cyc_device_id');
    if (id == null) {
      id = 'local_${const Uuid().v4()}';
      await prefs.setString('cyc_device_id', id);
    }
    return id;
  }

  DocumentReference<Map<String, dynamic>> get userDoc =>
      _db.collection('users').doc(userId);

  Future<void> _bootstrapUserDoc() async {
    try {
      final snap = await userDoc.get().timeout(const Duration(seconds: 5));
      if (!snap.exists) {
        await userDoc
            .set({
              'createdAt': FieldValue.serverTimestamp(),
              'username': _generateUsername(),
              'burdensReleased': 0,
              'memberSince': DateTime.now().year,
              'settings': {'musicEnabled': true, 'notificationsEnabled': true},
              'deliveryInfo': <String, dynamic>{},
              'splashRotationIndex': 0,
            })
            .timeout(const Duration(seconds: 5));
      }
    } catch (e) {
      debugPrint('User bootstrap failed: $e');
    }
  }

  String _generateUsername() {
    final suffix = userId.hashCode.abs() % 10000;
    return '@user${suffix.toString().padLeft(4, '0')}';
  }

  /// "Logout" with no login UI means start a fresh anonymous session.
  Future<void> resetIdentity() async {
    if (usingAnonAuth) {
      try {
        await _auth.currentUser?.delete().catchError((_) {});
        await _auth.signOut();
      } catch (e) {
        debugPrint('Anonymous reset failed: $e');
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cyc_device_id');
    usingAnonAuth = false;
    userId = await _resolveUserId();
    await _bootstrapUserDoc();
  }

  /// Sequential splash rotation scoped to this anonymous user/device.
  Future<int> nextSplashIndex(int themeCount) async {
    if (themeCount <= 0) return 0;

    try {
      final snap = await userDoc.get();
      final current = (snap.data()?['splashRotationIndex'] ?? 0) as int;
      final next = (current + 1) % themeCount;
      await userDoc.set({'splashRotationIndex': next}, SetOptions(merge: true));
      return current % themeCount;
    } catch (e) {
      debugPrint('Splash rotation update failed: $e');
      final prefs = await SharedPreferences.getInstance();
      final current = prefs.getInt('cyc_splash_rotation_index') ?? 0;
      await prefs.setInt(
        'cyc_splash_rotation_index',
        (current + 1) % themeCount,
      );
      return current % themeCount;
    }
  }
}
