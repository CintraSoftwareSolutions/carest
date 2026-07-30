import 'package:cloud_firestore/cloud_firestore.dart';

/// A Bible scripture shown on launch / welcome / cast screens.
class Scripture {
  final String id;
  final String text;
  final String reference;
  final int order;
  final bool isPriority;

  Scripture({
    required this.id,
    required this.text,
    required this.reference,
    required this.order,
    required this.isPriority,
  });

  factory Scripture.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return Scripture(
      id: doc.id,
      text: (d['text'] ?? '') as String,
      reference: (d['reference'] ?? '') as String,
      order: (d['order'] ?? 0) as int,
      isPriority: (d['isPriority'] ?? false) as bool,
    );
  }
}

/// A short reassurance/quote line (breath quotes and release quotes).
class QuoteLine {
  final String id;
  final String text;
  final int order;

  QuoteLine({required this.id, required this.text, required this.order});

  factory QuoteLine.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return QuoteLine(
      id: doc.id,
      text: (d['text'] ?? '') as String,
      order: (d['order'] ?? 0) as int,
    );
  }
}

/// A store product.
class Product {
  final String id;
  final String title;
  final double price;
  final String description;
  final String shortDesc;
  final String imageUrl;
  final String storeName;
  final String storeUrl;
  final bool active;

  /// Shopify Storefront variant GID (empty for Firestore-seeded products).
  /// Required to build a Shopify checkout URL.
  final String variantId;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.shortDesc,
    required this.imageUrl,
    required this.storeName,
    required this.storeUrl,
    required this.active,
    this.variantId = '',
  });

  factory Product.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return Product(
      id: doc.id,
      title: (d['title'] ?? '') as String,
      price: ((d['price'] ?? 0) as num).toDouble(),
      description: (d['description'] ?? '') as String,
      shortDesc: (d['shortDesc'] ?? '') as String,
      imageUrl: (d['imageUrl'] ?? '') as String,
      storeName: (d['storeName'] ?? 'Castcares.com') as String,
      storeUrl: (d['storeUrl'] ?? '') as String,
      active: (d['active'] ?? true) as bool,
      variantId: (d['variantId'] ?? '') as String,
    );
  }

  String get priceLabel => '\$${price.toStringAsFixed(2)}';
}

/// A cart line item (persisted under users/{id}/cart).
class CartItem {
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final String variantId;
  int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.variantId = '',
    this.quantity = 1,
  });

  factory CartItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return CartItem(
      productId: (d['productId'] ?? doc.id) as String,
      name: (d['name'] ?? '') as String,
      price: ((d['price'] ?? 0) as num).toDouble(),
      imageUrl: (d['imageUrl'] ?? '') as String,
      variantId: (d['variantId'] ?? '') as String,
      quantity: (d['quantity'] ?? 1) as int,
    );
  }

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'name': name,
    'price': price,
    'imageUrl': imageUrl,
    'variantId': variantId,
    'quantity': quantity,
  };

  double get lineTotal => price * quantity;
}

/// An in-app notification (persisted under users/{id}/notifications).
class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type;
  final DateTime createdAt;
  final bool read;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    required this.read,
  });

  factory AppNotification.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return AppNotification(
      id: doc.id,
      title: (d['title'] ?? '') as String,
      body: (d['body'] ?? '') as String,
      type: (d['type'] ?? 'general') as String,
      createdAt: (d['createdAt'] is Timestamp)
          ? (d['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      read: (d['read'] ?? false) as bool,
    );
  }
}

/// A legal document (privacy policy / terms) with sections.
class LegalDoc {
  final String title;
  final String lastUpdated;
  final List<LegalSection> sections;

  LegalDoc({
    required this.title,
    required this.lastUpdated,
    required this.sections,
  });

  factory LegalDoc.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    final rawSections = (d['sections'] ?? []) as List<dynamic>;
    return LegalDoc(
      title: (d['title'] ?? '') as String,
      lastUpdated: (d['lastUpdated'] ?? '') as String,
      sections: rawSections
          .map((s) => LegalSection(
                heading: (s['heading'] ?? '') as String,
                body: (s['body'] ?? '') as String,
              ))
          .toList(),
    );
  }
}

class LegalSection {
  final String heading;
  final String body;
  LegalSection({required this.heading, required this.body});
}

/// An FAQ entry for Help & Support.
class Faq {
  final String id;
  final String question;
  final String answer;
  final int order;

  Faq({
    required this.id,
    required this.question,
    required this.answer,
    required this.order,
  });

  factory Faq.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return Faq(
      id: doc.id,
      question: (d['question'] ?? '') as String,
      answer: (d['answer'] ?? '') as String,
      order: (d['order'] ?? 0) as int,
    );
  }
}
