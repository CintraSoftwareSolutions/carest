/// Shopify Storefront API configuration.
///
/// Paste the client's values here to switch the Store from Firestore seed
/// products to their live Shopify catalog. Both must be non-empty for the
/// Shopify integration to activate; otherwise the app falls back to Firestore.
///
/// - [storeDomain]: the myshopify domain, e.g. "your-store.myshopify.com"
///   (NOT the custom/primary domain — use the *.myshopify.com one).
/// - [storefrontAccessToken]: the Storefront API access token created under
///   Shopify admin → Settings → Apps and sales channels → Develop apps →
///   (your app) → API credentials → Storefront API access token.
///   NOTE: the Storefront token is designed for client-side use, so it is safe
///   to ship inside the app (unlike the Admin API token, which must never be
///   embedded here).
class ShopifyConfig {
  static const String storeDomain = 'castyourcaresapparel.myshopify.com';
  static const String storefrontAccessToken = '8dbbd1382e599061735f0d5397264e39';

  /// Storefront API version. Bump to a current version periodically.
  static const String apiVersion = '2025-01';

  static bool get isConfigured =>
      storeDomain.isNotEmpty && storefrontAccessToken.isNotEmpty;

  static Uri get endpoint =>
      Uri.parse('https://$storeDomain/api/$apiVersion/graphql.json');
}
