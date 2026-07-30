import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../config/shopify_config.dart';
import '../models/models.dart';

/// Talks to the Shopify Storefront API (GraphQL).
///
/// Activates only when [ShopifyConfig] has a domain + Storefront token.
/// Provides the live product catalog and builds a hosted checkout URL for the
/// cart (payment is handled entirely by Shopify's secure checkout).
class ShopifyService extends GetxService {
  static ShopifyService get to => Get.find();

  bool get isEnabled => ShopifyConfig.isConfigured;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'X-Shopify-Storefront-Access-Token':
            ShopifyConfig.storefrontAccessToken,
      };

  /// Fetches active products from the Storefront API.
  Future<List<Product>> getProducts({int first = 50}) async {
    if (!isEnabled) return [];
    const query = r'''
      query Products($first: Int!) {
        products(first: $first) {
          edges {
            node {
              id
              title
              description
              onlineStoreUrl
              featuredImage { url }
              priceRange { minVariantPrice { amount currencyCode } }
              variants(first: 1) { edges { node { id } } }
            }
          }
        }
      }
    ''';
    try {
      final res = await http
          .post(
            ShopifyConfig.endpoint,
            headers: _headers,
            body: jsonEncode({
              'query': query,
              'variables': {'first': first},
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (res.statusCode != 200) {
        debugPrint('Shopify products HTTP ${res.statusCode}: ${res.body}');
        return [];
      }
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (data['errors'] != null) {
        debugPrint('Shopify products errors: ${data['errors']}');
        return [];
      }
      final edges = (data['data']?['products']?['edges'] ?? []) as List;
      return edges.map<Product>((e) {
        final node = e['node'] as Map<String, dynamic>;
        final price = double.tryParse(
                node['priceRange']?['minVariantPrice']?['amount']?.toString() ??
                    '0') ??
            0;
        final desc = (node['description'] ?? '') as String;
        final variantEdges = (node['variants']?['edges'] ?? []) as List;
        final variantId = variantEdges.isNotEmpty
            ? (variantEdges.first['node']['id'] as String)
            : '';
        return Product(
          id: (node['id'] ?? '') as String,
          title: (node['title'] ?? '') as String,
          price: price,
          description: desc,
          shortDesc: desc.length > 90 ? '${desc.substring(0, 90)}…' : desc,
          imageUrl: (node['featuredImage']?['url'] ?? '') as String,
          storeName: ShopifyConfig.storeDomain,
          storeUrl: (node['onlineStoreUrl'] ?? '') as String,
          active: true,
          variantId: variantId,
        );
      }).toList();
    } catch (e) {
      debugPrint('Shopify getProducts failed: $e');
      return [];
    }
  }

  /// Creates a Shopify cart from the given line items and returns the hosted
  /// checkout URL to open in a browser. Returns null on failure.
  Future<String?> createCheckoutUrl(List<CartItem> items) async {
    if (!isEnabled) return null;
    final lines = items
        .where((i) => i.variantId.isNotEmpty)
        .map((i) => {'merchandiseId': i.variantId, 'quantity': i.quantity})
        .toList();
    if (lines.isEmpty) return null;

    const mutation = r'''
      mutation CartCreate($lines: [CartLineInput!]!) {
        cartCreate(input: { lines: $lines }) {
          cart { checkoutUrl }
          userErrors { message }
        }
      }
    ''';
    try {
      final res = await http
          .post(
            ShopifyConfig.endpoint,
            headers: _headers,
            body: jsonEncode({
              'query': mutation,
              'variables': {'lines': lines},
            }),
          )
          .timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) {
        debugPrint('Shopify cart HTTP ${res.statusCode}: ${res.body}');
        return null;
      }
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final url =
          data['data']?['cartCreate']?['cart']?['checkoutUrl'] as String?;
      return url;
    } catch (e) {
      debugPrint('Shopify createCheckoutUrl failed: $e');
      return null;
    }
  }
}
