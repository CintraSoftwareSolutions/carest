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

  /// Initializes the Stripe SDK with the publishable key. Call once at startup.
  Future<StripeService> init() async {
    try {
      if (StripeConfig.isConfigured) {
        stripe.Stripe.publishableKey = StripeConfig.publishableKey;
        stripe.Stripe.merchantIdentifier = 'merchant.com.castyourcare.app';
        await stripe.Stripe.instance.applySettings();
      }
    } catch (e) {
      debugPrint('Stripe init failed: $e');
    }
    return this;
  }

  /// Runs the full donation payment for [amount] (in dollars).
  Future<PaymentResult> payDonation(double amount) async {
    try {
      // 1) Ask our Cloud Function for a PaymentIntent client secret.
      final callable = _functions.httpsCallable('createDonationPaymentIntent');
      final res = await callable.call<Map<String, dynamic>>({
        'amount': amount,
        'currency': 'usd',
      });
      final clientSecret = res.data['clientSecret'] as String?;
      if (clientSecret == null || clientSecret.isEmpty) {
        return PaymentResult.failed;
      }

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
      return PaymentResult.success;
    } on stripe.StripeException catch (e) {
      // User canceled the sheet.
      if (e.error.code == stripe.FailureCode.Canceled) {
        return PaymentResult.canceled;
      }
      debugPrint('Stripe payment error: ${e.error.localizedMessage}');
      return PaymentResult.failed;
    } catch (e) {
      debugPrint('Donation payment failed: $e');
      return PaymentResult.failed;
    }
  }
}
