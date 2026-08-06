import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Generates gentle reflection suggestions for the "What's in your heart?"
/// screen using Gemini (Firebase AI Logic). If the API is unavailable
/// (e.g. Firebase AI Logic not enabled yet), it falls back to on-device
/// heuristic rephrasings so the feature never breaks.
///
/// IMPORTANT: the user's text is sent to Gemini only transiently to produce
/// suggestions. It is never persisted anywhere (symbolic-release requirement).
class AiService extends GetxService {
  static AiService get to => Get.find();

  GenerativeModel? _model;

  @override
  void onInit() {
    super.onInit();
    _tryInitModel();
  }

  void _tryInitModel() => _ensureModel();

  /// Lazily builds the model. Retries on each call so that enabling
  /// Firebase AI Logic after startup takes effect without a reinstall.
  GenerativeModel? _ensureModel() {
    if (_model != null) return _model;
    try {
      // Uses the Gemini Developer API backend (free tier, no billing required).
      _model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.0-flash',
        generationConfig: GenerationConfig(
          temperature: 0.7,
          responseMimeType: 'application/json',
        ),
      );
    } catch (e) {
      debugPrint('AI: model init failed: $e');
      _model = null;
    }
    return _model;
  }

  /// Returns up to 2 short, gentle rephrasings of what the user typed —
  /// each phrased as something they can hand over to God.
  Future<List<String>> reflectionSuggestions(String burden) async {
    final trimmed = burden.trim();
    if (trimmed.isEmpty) return [];

    final model = _ensureModel();
    if (model != null) {
      try {
        final prompt =
            'A person using a Christian faith app wrote what is weighing on '
            'their heart. Gently rephrase it into exactly 2 short first-person '
            'reflections (max ~12 words each) they can surrender to God. Warm, '
            'calm, non-clinical. Do not add advice or scripture. '
            'Return ONLY JSON: {"suggestions":["...","..."]}\n\n'
            'What they wrote: "$trimmed"';
        final res = await model
            .generateContent([Content.text(prompt)]).timeout(
                const Duration(seconds: 15));
        final text = res.text;
        if (text != null && text.trim().isNotEmpty) {
          final parsed = _parseSuggestions(text);
          if (parsed.isNotEmpty) {
            debugPrint('AI: Gemini suggestions OK');
            return parsed.take(2).toList();
          }
        }
        debugPrint('AI: Gemini returned no usable text, using fallback');
      } catch (e) {
        debugPrint('AI: Gemini call failed: $e');
      }
    }
    return _localSuggestions(trimmed);
  }

  /// Optional: a single personalized comforting line for the release screen.
  Future<String?> comfortLine(String burden) async {
    final trimmed = burden.trim();
    final model = _ensureModel();
    if (trimmed.isEmpty || model == null) return null;
    try {
      final prompt =
          'Write ONE short comforting sentence (max ~14 words) reassuring a '
          'Christian that God is holding this specific worry. No scripture ref. '
          'Return ONLY JSON: {"line":"..."}\n\nThe worry: "$trimmed"';
      final res = await model
          .generateContent([Content.text(prompt)]).timeout(
              const Duration(seconds: 15));
      final text = res.text;
      if (text == null) return null;
      final map = _tryJson(text);
      final line = map?['line'];
      if (line is String && line.trim().isNotEmpty) return line.trim();
    } catch (_) {}
    return null;
  }

  List<String> _parseSuggestions(String raw) {
    final map = _tryJson(raw);
    final list = map?['suggestions'];
    if (list is List) {
      return list
          .whereType<String>()
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return [];
  }

  Map<String, dynamic>? _tryJson(String raw) {
    try {
      var s = raw.trim();
      // Strip markdown code fences if present.
      s = s.replaceAll(RegExp(r'^```(json)?'), '').replaceAll('```', '').trim();
      final start = s.indexOf('{');
      final end = s.lastIndexOf('}');
      if (start >= 0 && end > start) s = s.substring(start, end + 1);
      return jsonDecode(s) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// On-device rephrasings used when Gemini is unavailable.
  ///
  /// These are always grammatical, gentle first-person surrender statements.
  /// We intentionally do NOT splice the user's raw text into a sentence (that
  /// produced broken English like "I place i am worried..."). Instead we detect
  /// a rough theme and return two natural phrasings.
  List<String> _localSuggestions(String burden) {
    final lower = burden.toLowerCase();

    if (RegExp(r'job|work|career|money|financ|provision|bill|debt|income')
        .hasMatch(lower)) {
      return [
        'I give God my work and finances, and trust Him to provide.',
        'I place my need for provision in His hands.',
      ];
    }
    if (RegExp(r'health|sick|ill|pain|heal|anxi|fear|afraid|scared|worry|stress|overwhelm')
        .hasMatch(lower)) {
      return [
        'I hand God my fears and the things I can’t control.',
        'I trust God with my health and my peace of mind.',
      ];
    }
    if (RegExp(r'family|kid|child|son|daughter|marriage|husband|wife|relationship|friend|parent')
        .hasMatch(lower)) {
      return [
        'I place the people I love in God’s care.',
        'I trust God with my relationships and those close to me.',
      ];
    }
    if (RegExp(r'future|plan|uncertain|unknown|tomorrow|decision|direction|purpose')
        .hasMatch(lower)) {
      return [
        'I surrender my uncertain future to God.',
        'I trust God with what lies ahead, one day at a time.',
      ];
    }
    // Generic, always-grammatical fallback.
    return [
      'I place this burden in God’s hands.',
      'I trust God with what’s weighing on my heart.',
    ];
  }
}
