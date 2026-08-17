import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:get/get.dart';

import '../../config/stripe_config.dart';

/// Result of attempting a donation payment.
enum PaymentResult { success, canceled, failed }

/// Handles Stripe donation payments end-to-end:
/// app → Cloud Function (creates PaymentIntent with the secret key) →
/// Stripe native Payment Sheet → confirmation.
class StripeService extends GetxService {
  static StripeService get to => Get.find();

  final _functions = FirebaseFunctions.instance;

  bool _initialized = false;

  /// Initializes the Stripe SDK with the publishable key. Call once at startup.
  Future<StripeService> init() async {
    try {
      if (StripeConfig.isConfigured) {
        stripe.Stripe.publishableKey = StripeConfig.publishableKey;
        // NOTE: no merchantIdentifier here — setting one without a configured
        // Apple Pay merchant can stall initPaymentSheet on iOS. We don't pass
        // an applePay config to the sheet, so it isn't needed.
        await stripe.Stripe.instance.applySettings();
        _initialized = true;
        debugPrint('Stripe: initialized');
      }
    } catch (e) {
      debugPrint('Stripe init failed: $e');
    }
    return this;
  }

  /// Runs the full donation payment for [amount] (in dollars).
  Future<PaymentResult> payDonation(double amount) async {
    // Make sure the SDK is initialized (defensive — in case init() was skipped
    // or failed at startup, e.g. on a cold iOS launch).
    if (!_initialized) {
      await init();
      if (!_initialized) {
        debugPrint('Stripe: not initialized, cannot pay');
        return PaymentResult.failed;
      }
    }
    try {
      // 1) Ask our Cloud Function for a PaymentIntent client secret.
      // Bound the call with timeouts so the UI can never hang forever.
      debugPrint('Stripe: requesting PaymentIntent…');
      final callable = _functions.httpsCallable(
        'createDonationPaymentIntent',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
      );
      final res = await callable.call<Map<String, dynamic>>({
        'amount': amount,
        'currency': 'usd',
      }).timeout(const Duration(seconds: 35));
      final clientSecret = res.data['clientSecret'] as String?;
      if (clientSecret == null || clientSecret.isEmpty) {
        debugPrint('Stripe: no clientSecret returned');
        return PaymentResult.failed;
      }
      debugPrint('Stripe: got clientSecret, presenting sheet');

      // 2) Initialize + present Stripe's native Payment Sheet.
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: StripeConfig.merchantDisplayName,
          allowsDelayedPaymentMethods: false,
        ),
      );
      await stripe.Stripe.instance.presentPaymentSheet();

      // If presentPaymentSheet completes without throwing, payment succeeded.
      debugPrint('Stripe: payment success');
      return PaymentResult.success;
    } on stripe.StripeException catch (e) {
      // User canceled the sheet.
      if (e.error.code == stripe.FailureCode.Canceled) {
        return PaymentResult.canceled;
      }
      debugPrint('Stripe payment error: ${e.error.localizedMessage}');
      return PaymentResult.failed;
    } on TimeoutException {
      debugPrint('Stripe: PaymentIntent request timed out');
      return PaymentResult.failed;
    } catch (e) {
      debugPrint('Donation payment failed: $e');
      return PaymentResult.failed;
    }
  }
}
