import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/models.dart';
import '../seed_data.dart';

/// Reads app content (scriptures, quotes, products, faqs, legal) from Firestore,
/// and seeds it on first run. Every getter falls back to bundled [SeedData]
/// if Firestore is unreachable, so the UI is never empty.
class ContentRepository extends GetxService {
  static ContentRepository get to => Get.find();

  final _db = FirebaseFirestore.instance;

  /// Seeds Firestore content collections once (guarded by app_config/main).
  /// Safe to call on every launch — it no-ops if already seeded.
  Future<void> seedIfNeeded() async {
    try {
      final cfg = await _db.collection('app_config').doc('main').get();
      if (cfg.data()?['contentVersion'] == SeedData.contentVersion) return;

      final batch = _db.batch();
      batch.set(_db.collection('app_config').doc('main'), SeedData.appConfig);
      for (final s in SeedData.scriptures) {
        batch.set(
          _db.collection('scriptures').doc(s['id'] as String),
          Map<String, dynamic>.from(s)..remove('id'),
        );
      }
      for (final q in SeedData.breathQuotes) {
        batch.set(
          _db.collection('breath_quotes').doc(q['id'] as String),
          Map<String, dynamic>.from(q)..remove('id'),
        );
      }
      for (final q in SeedData.releaseQuotes) {
        batch.set(
          _db.collection('release_quotes').doc(q['id'] as String),
          Map<String, dynamic>.from(q)..remove('id'),
        );
      }
      for (final p in SeedData.products) {
        batch.set(
          _db.collection('products').doc(p['id'] as String),
          Map<String, dynamic>.from(p)..remove('id'),
        );
      }
      for (final f in SeedData.faqs) {
        batch.set(
          _db.collection('faqs').doc(f['id'] as String),
          Map<String, dynamic>.from(f)..remove('id'),
        );
      }
      batch.set(_db.collection('legal').doc('privacy'), SeedData.privacy);
      batch.set(_db.collection('legal').doc('terms'), SeedData.terms);
      await batch.commit();
    } catch (_) {
      // Seeding failed (offline or rules) — fallbacks cover the UI.
    }
  }

  Future<List<Scripture>> getScriptures() async {
    try {
      final snap = await _db.collection('scriptures').orderBy('order').get();
      if (snap.docs.isNotEmpty) {
        return snap.docs.map((d) => Scripture.fromDoc(d)).toList();
      }
    } catch (_) {}
    return SeedData.scriptures
        .map(
          (s) => Scripture(
            id: s['id'] as String,
            text: s['text'] as String,
            reference: s['reference'] as String,
            order: s['order'] as int,
            isPriority: s['isPriority'] as bool,
          ),
        )
        .toList();
  }

  Future<List<QuoteLine>> _quotes(
    String collection,
    List<Map<String, dynamic>> fallback,
  ) async {
    try {
      final snap = await _db.collection(collection).orderBy('order').get();
      if (snap.docs.isNotEmpty) {
        return snap.docs.map((d) => QuoteLine.fromDoc(d)).toList();
      }
    } catch (_) {}
    return fallback
        .map(
          (q) => QuoteLine(
            id: q['id'] as String,
            text: q['text'] as String,
            order: q['order'] as int,
          ),
        )
        .toList();
  }

  Future<List<QuoteLine>> getBreathQuotes() =>
      _quotes('breath_quotes', SeedData.breathQuotes);

  Future<List<QuoteLine>> getReleaseQuotes() =>
      _quotes('release_quotes', SeedData.releaseQuotes);

  Future<List<Product>> getProducts() async {
    try {
      final snap = await _db
          .collection('products')
          .where('active', isEqualTo: true)
          .get();
      if (snap.docs.isNotEmpty) {
        return snap.docs.map((d) => Product.fromDoc(d)).toList();
      }
    } catch (_) {}
    return SeedData.products
        .map(
          (p) => Product(
            id: p['id'] as String,
            title: p['title'] as String,
            price: (p['price'] as num).toDouble(),
            description: p['description'] as String,
            shortDesc: p['shortDesc'] as String,
            imageUrl: p['imageUrl'] as String,
            storeName: p['storeName'] as String,
            storeUrl: p['storeUrl'] as String,
            active: p['active'] as bool,
          ),
        )
        .toList();
  }

  Future<List<Faq>> getFaqs() async {
    try {
      final snap = await _db.collection('faqs').orderBy('order').get();
      if (snap.docs.isNotEmpty) {
        return snap.docs.map((d) => Faq.fromDoc(d)).toList();
      }
    } catch (_) {}
    return SeedData.faqs
        .map(
          (f) => Faq(
            id: f['id'] as String,
            question: f['question'] as String,
            answer: f['answer'] as String,
            order: f['order'] as int,
          ),
        )
        .toList();
  }

  Future<LegalDoc> getLegal(String which) async {
    final fallback = which == 'terms' ? SeedData.terms : SeedData.privacy;
    try {
      final doc = await _db.collection('legal').doc(which).get();
      if (doc.exists) return LegalDoc.fromDoc(doc);
    } catch (_) {}
    return LegalDoc(
      title: fallback['title'] as String,
      lastUpdated: fallback['lastUpdated'] as String,
      sections: (fallback['sections'] as List)
          .map(
            (s) => LegalSection(
              heading: s['heading'] as String,
              body: s['body'] as String,
            ),
          )
          .toList(),
    );
  }

  Future<List<int>> getDonationSuggestions() async {
    try {
      final doc = await _db.collection('app_config').doc('main').get();
      final list = doc.data()?['donationSuggestions'];
      if (list is List) return list.map((e) => (e as num).toInt()).toList();
    } catch (_) {}
    return (SeedData.appConfig['donationSuggestions'] as List)
        .map((e) => e as int)
        .toList();
  }

  Future<String?> getMusicTrackUrl() async {
    try {
      final doc = await _db.collection('app_config').doc('main').get();
      final url = doc.data()?['musicTrackUrl'];
      if (url is String && url.isNotEmpty) return url;
    } catch (_) {}
    return null;
  }
}
