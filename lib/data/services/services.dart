import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../firebase_options.dart';
import 'ai_service.dart';
import 'audio_service.dart';
import 'content_repository.dart';
import 'session_service.dart';
import 'user_repository.dart';

/// Initializes Firebase and registers all app services/repositories with GetX.
///
/// Startup must not wait on Firestore network calls. Content seeding, profile
/// reads, and audio config happen after the first frame path is unblocked.
class AppServices {
  static Future<void> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 8));
    } catch (e) {
      debugPrint('Firebase initialize failed: $e');
    }

    await Get.putAsync(() => SessionService().init());

    final content = Get.put(ContentRepository());
    Get.put(UserRepository());
    Get.put(AiService());

    unawaited(_seedContent(content));
    unawaited(_initAudio(content));
  }

  static Future<void> _seedContent(ContentRepository content) async {
    try {
      await content.seedIfNeeded().timeout(const Duration(seconds: 20));
    } catch (e) {
      debugPrint('Content seed skipped: $e');
    }
  }

  static Future<void> _initAudio(ContentRepository content) async {
    var musicEnabled = true;
    try {
      final user = await UserRepository.to.getUser().timeout(
        const Duration(seconds: 3),
      );
      final settings = Map<String, dynamic>.from(user['settings'] ?? {});
      musicEnabled = (settings['musicEnabled'] ?? true) as bool;
    } catch (e) {
      debugPrint('Saved music setting unavailable: $e');
    }

    String? trackUrl;
    try {
      trackUrl = await content.getMusicTrackUrl().timeout(
        const Duration(seconds: 3),
      );
    } catch (e) {
      debugPrint('Music config unavailable: $e');
    }

    try {
      await Get.putAsync(
        () =>
            AudioService().init(musicEnabled: musicEnabled, trackUrl: trackUrl),
      ).timeout(const Duration(seconds: 4));
    } catch (e) {
      debugPrint('Audio service unavailable: $e');
    }
  }
}
