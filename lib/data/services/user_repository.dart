import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/models.dart';
import 'session_service.dart';

/// Reads/writes per-device user data under users/{userId}.
/// NOTE: burden submission text is intentionally NEVER persisted here.
class UserRepository extends GetxService {
  static UserRepository get to => Get.find();

  DocumentReference<Map<String, dynamic>> get _userDoc =>
      SessionService.to.userDoc;

  // ---- Profile / counter ----

  Stream<DocumentSnapshot<Map<String, dynamic>>> userStream() =>
      _userDoc.snapshots();

  Future<Map<String, dynamic>> getUser() async {
    try {
      final snap = await _userDoc.get();
      return snap.data() ?? {};
    } catch (_) {
      return {};
    }
  }

  /// Increments the released-burden counter (the only thing recorded on cast).
  Future<void> incrementBurdensReleased() async {
    try {
      await _userDoc.set(
        {'burdensReleased': FieldValue.increment(1)},
        SetOptions(merge: true),
      );
    } catch (_) {}
  }

  // ---- Settings ----

  Future<void> setSetting(String key, bool value) async {
    try {
      await _userDoc.set(
        {'settings': {key: value}},
        SetOptions(merge: true),
      );
    } catch (_) {}
  }

  // ---- Delivery info ----

  Future<void> saveDeliveryInfo(Map<String, dynamic> info) async {
    try {
      await _userDoc.set({'deliveryInfo': info}, SetOptions(merge: true));
    } catch (_) {}
  }

  Future<Map<String, dynamic>> getDeliveryInfo() async {
    final u = await getUser();
    return Map<String, dynamic>.from(u['deliveryInfo'] ?? {});
  }

  // ---- Notifications ----

  CollectionReference<Map<String, dynamic>> get _notifications =>
      _userDoc.collection('notifications');

  Stream<List<AppNotification>> notificationsStream() {
    try {
      return _notifications
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((s) => s.docs.map((d) => AppNotification.fromDoc(d)).toList());
    } catch (_) {
      return const Stream.empty();
    }
  }

  Future<void> addNotification(String title, String body,
      {String type = 'general'}) async {
    try {
      await _notifications.add({
        'title': title,
        'body': body,
        'type': type,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _notifications.doc(id).delete();
    } catch (_) {}
  }

  // ---- Cart ----

  CollectionReference<Map<String, dynamic>> get _cart => _userDoc.collection('cart');

  Stream<List<CartItem>> cartStream() {
    try {
      return _cart.snapshots().map(
          (s) => s.docs.map((d) => CartItem.fromDoc(d)).toList());
    } catch (_) {
      return const Stream.empty();
    }
  }

  Future<List<CartItem>> getCart() async {
    try {
      final snap = await _cart.get();
      return snap.docs.map((d) => CartItem.fromDoc(d)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Firestore doc IDs can't contain '/', but Shopify product GIDs
  /// (e.g. gid://shopify/Product/123) do — so sanitize for the doc key.
  String _cartDocId(String productId) =>
      productId.replaceAll(RegExp(r'[/#?]'), '_');

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    try {
      final ref = _cart.doc(_cartDocId(product.id));
      final existing = await ref.get();
      if (existing.exists) {
        await ref.set(
            {'quantity': FieldValue.increment(quantity)},
            SetOptions(merge: true));
      } else {
        await ref.set(CartItem(
          productId: product.id,
          name: product.title,
          price: product.price,
          imageUrl: product.imageUrl,
          variantId: product.variantId,
          quantity: quantity,
        ).toMap());
      }
    } catch (_) {}
  }

  Future<void> setCartQuantity(String productId, int quantity) async {
    try {
      final ref = _cart.doc(_cartDocId(productId));
      if (quantity <= 0) {
        await ref.delete();
      } else {
        await ref.set({'quantity': quantity}, SetOptions(merge: true));
      }
    } catch (_) {}
  }

  Future<void> removeFromCart(String productId) async {
    try {
      await _cart.doc(_cartDocId(productId)).delete();
    } catch (_) {}
  }

  Future<void> clearCart() async {
    try {
      final snap = await _cart.get();
      for (final d in snap.docs) {
        await d.reference.delete();
      }
    } catch (_) {}
  }

  // ---- Orders ----

  Future<void> placeOrder({
    required List<CartItem> items,
    required double itemsTotal,
    required double deliveryFee,
    required Map<String, dynamic> deliveryInfo,
  }) async {
    try {
      await _userDoc.collection('orders').add({
        'items': items.map((e) => e.toMap()).toList(),
        'itemsTotal': itemsTotal,
        'deliveryFee': deliveryFee,
        'total': itemsTotal + deliveryFee,
        'deliveryInfo': deliveryInfo,
        'status': 'paid',
        'createdAt': FieldValue.serverTimestamp(),
      });
      await addNotification(
        'Order Placed!',
        'You have successfully placed an order.',
        type: 'order',
      );
    } catch (_) {}
  }

  // ---- Donations ----

  Future<void> recordDonation({
    required double amount,
    required String method,
  }) async {
    try {
      await _userDoc.collection('donations').add({
        'amount': amount,
        'method': method,
        'status': 'completed',
        'createdAt': FieldValue.serverTimestamp(),
      });
      await addNotification(
        'Thank you for your support!',
        'Your donation of \$${amount.toStringAsFixed(2)} was received.',
        type: 'donation',
      );
    } catch (_) {}
  }
}
