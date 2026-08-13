import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Generates gentle reflection suggestions for the "What's in your heart?"
/// screen and an optional comfort line for the release screen.
///
/// Gemini runs SERVER-SIDE in a Cloud Function (generateAiReflection), so:
///  - the app needs no App Check / Play Integrity,
///  - the Gemini API key lives only in a Firebase secret (rotate it by updating
///    the secret + redeploying — no app change needed).
///
/// If the call fails for any reason, we fall back to on-device suggestions so
/// the feature never breaks. The user's text is sent only transiently to
/// generate suggestions and is never stored.
class AiService extends GetxService {
  static AiService get to => Get.find();

  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Up to 2 short, gentle rephrasings the user can adopt.
  Future<List<String>> reflectionSuggestions(String burden) async {
    final trimmed = burden.trim();
    if (trimmed.isEmpty) return [];
    try {
      final res = await _functions
          .httpsCallable('generateAiReflection')
          .call<Map<String, dynamic>>({
            'burden': trimmed,
            'mode': 'suggestions',
          })
          .timeout(const Duration(seconds: 15));
      final raw = (res.data['suggestions'] as List?) ?? const [];
      final list = raw
          .whereType<String>()
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      if (list.isNotEmpty) {
        debugPrint('AI: Gemini suggestions OK');
        return list.take(2).toList();
      }
      debugPrint('AI: empty suggestions, using fallback');
    } catch (e) {
      debugPrint('AI: reflection call failed: $e');
    }
    return _localSuggestions(trimmed);
  }

  /// A single personalized comforting line for the release screen (or null).
  Future<String?> comfortLine(String burden) async {
    final trimmed = burden.trim();
    if (trimmed.isEmpty) return null;
    try {
      final res = await _functions
          .httpsCallable('generateAiReflection')
          .call<Map<String, dynamic>>({
            'burden': trimmed,
            'mode': 'comfort',
          })
          .timeout(const Duration(seconds: 15));
      final line = res.data['line'];
      if (line is String && line.trim().isNotEmpty) return line.trim();
    } catch (e) {
      debugPrint('AI: comfort call failed: $e');
    }
    return null;
  }

  /// On-device rephrasings used when the AI call is unavailable.
  /// Always grammatical, gentle first-person surrender statements.
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
    return [
      'I place this burden in God’s hands.',
      'I trust God with what’s weighing on my heart.',
    ];
  }
}
