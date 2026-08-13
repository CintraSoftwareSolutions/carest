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
const GEMINI_API_KEY = defineSecret("GEMINI_API_KEY");

// Always-current flash model alias, so a future model deprecation doesn't break us.
const GEMINI_MODEL = "gemini-flash-latest";

/**
 * Server-side Gemini reflections for the "What's in your heart?" screen and the
 * release comfort line. Keeping this server-side means the app never needs
 * App Check, and the API key can be rotated by updating the GEMINI_API_KEY
 * secret + redeploying — with NO app code change.
 *
 * data: { burden: string, mode?: "suggestions" | "comfort" }
 * returns: { suggestions: string[] }  or  { line: string|null }
 */
exports.generateAiReflection = onCall(
    {secrets: [GEMINI_API_KEY], cors: true},
    async (request) => {
      const burden = String((request.data && request.data.burden) || "").trim();
      const mode = String((request.data && request.data.mode) || "suggestions");
      if (!burden) return {suggestions: [], line: null};

      const prompt = mode === "comfort" ?
        "Write ONE short comforting sentence (max ~14 words) reassuring a " +
          "Christian that God is holding this specific worry. No scripture " +
          "reference. Return ONLY JSON: {\"line\":\"...\"}\n\nThe worry: \"" +
          burden + "\"" :
        "A person using a Christian faith app wrote what is weighing on their " +
          "heart. Gently rephrase it into exactly 2 short first-person " +
          "reflections (max ~14 words each) they can surrender to God. Warm, " +
          "calm, non-clinical. No advice or scripture. Return ONLY JSON: " +
          "{\"suggestions\":[\"...\",\"...\"]}\n\nWhat they wrote: \"" +
          burden + "\"";

      try {
        const res = await fetch(
            "https://generativelanguage.googleapis.com/v1beta/models/" +
              GEMINI_MODEL + ":generateContent",
            {
              method: "POST",
              headers: {
                "Content-Type": "application/json",
                "x-goog-api-key": GEMINI_API_KEY.value(),
              },
              body: JSON.stringify({
                contents: [{parts: [{text: prompt}], role: "user"}],
                generationConfig: {
                  responseMimeType: "application/json",
                  temperature: 0.7,
                },
              }),
            },
        );
        if (!res.ok) {
          logger.error("Gemini HTTP " + res.status, await res.text());
          return {suggestions: [], line: null};
        }
        const data = await res.json();
        const text =
          data?.candidates?.[0]?.content?.parts?.[0]?.text || "{}";
        const parsed = JSON.parse(text);
        if (mode === "comfort") {
          return {line: typeof parsed.line === "string" ? parsed.line : null};
        }
        const suggestions = Array.isArray(parsed.suggestions) ?
          parsed.suggestions.filter((s) => typeof s === "string").slice(0, 2) :
          [];
        return {suggestions};
      } catch (err) {
        logger.error("Gemini reflection failed", err);
        // Return empty so the app falls back to on-device suggestions.
        return {suggestions: [], line: null};
      }
    },
);

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
