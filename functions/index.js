/**
 * Cloud Functions for Cast Your Cares — Stripe donations.
 *
 * The Stripe SECRET key lives only here (server-side), supplied via a Firebase
 * secret named STRIPE_SECRET_KEY. It is never shipped in the app.
 *
 * Set it once with:
 *   firebase functions:secrets:set STRIPE_SECRET_KEY
 * (paste the sk_test_... key for testing, sk_live_... for production)
 */
const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {defineSecret} = require("firebase-functions/params");
const logger = require("firebase-functions/logger");
const Stripe = require("stripe");

const STRIPE_SECRET_KEY = defineSecret("STRIPE_SECRET_KEY");

/**
 * Creates a Stripe PaymentIntent for a donation and returns its client secret.
 * The Flutter app presents Stripe's native Payment Sheet with this secret.
 *
 * data: { amount: number (in dollars), currency?: string }
 * returns: { clientSecret, paymentIntentId, publishableAmount }
 */
exports.createDonationPaymentIntent = onCall(
    {secrets: [STRIPE_SECRET_KEY], cors: true},
    async (request) => {
      const amount = Number(request.data && request.data.amount);
      const currency = (request.data && request.data.currency) || "usd";

      if (!Number.isFinite(amount) || amount <= 0) {
        throw new HttpsError(
            "invalid-argument",
            "A positive donation amount is required.",
        );
      }
      // Stripe expects the amount in the smallest currency unit (cents).
      const amountInCents = Math.round(amount * 100);
      if (amountInCents < 50) {
        throw new HttpsError(
            "invalid-argument",
            "Minimum donation is $0.50.",
        );
      }

      try {
        const stripe = Stripe(STRIPE_SECRET_KEY.value());
        const paymentIntent = await stripe.paymentIntents.create({
          amount: amountInCents,
          currency,
          // Let Stripe enable card + wallets (Apple/Google Pay) automatically.
          automatic_payment_methods: {enabled: true},
          description: "Cast Your Cares — donation",
          metadata: {
            app: "castyourcare",
            uid: (request.auth && request.auth.uid) || "anonymous",
          },
        });

        return {
          clientSecret: paymentIntent.client_secret,
          paymentIntentId: paymentIntent.id,
        };
      } catch (err) {
        logger.error("Stripe PaymentIntent creation failed", err);
        throw new HttpsError("internal", "Could not start the payment.");
      }
    },
);
