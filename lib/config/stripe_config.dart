/// Stripe configuration for the app (client-side).
///
/// Only the PUBLISHABLE key lives in the app — it is safe to ship. The SECRET
/// key is never here; it lives only in the Cloud Function (Firebase secret
/// STRIPE_SECRET_KEY).
///
/// IMPORTANT: the publishable key and the function's secret key must be the
/// SAME mode. For emulator testing use the TEST publishable key (pk_test_…);
/// for production use the LIVE key (pk_live_…).
class StripeConfig {
  // TEST publishable key (used for emulator testing with Stripe test cards).
  // For production, swap this for the LIVE key:
  //   pk_live_51TrIsAIpHdOLxa6nxnPsu3JBRYCAtyuCvWjDcK1qESLADfLXZ37y6apa7FR5SUIYgOeLwf8zLOkja8hN7V1PrWWm00R4PWxVrG
  static const String publishableKey =
      'pk_test_51TrIsKRD0MoFDcV2QQY6RzpXVbw7QLLjLs25uALQU5FukUWuVLriuOE6w8Pgt7W4DCrec5jeKOZkmE2PwnceObiZ00PIvnRiK3';

  /// Shown on the native Stripe Payment Sheet.
  static const String merchantDisplayName = 'Cast Your Cares';

  static bool get isConfigured => publishableKey.startsWith('pk_');
}
