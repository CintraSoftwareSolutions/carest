import 'package:get/get.dart';

import '../data/models/models.dart';
import '../data/services/content_repository.dart';
import '../data/services/user_repository.dart';

/// Manages store products and the persisted cart (backed by Firestore).
class StoreController extends GetxController {
  static StoreController get to => Get.find();

  final RxList<Product> products = <Product>[].obs;
  final RxList<CartItem> cart = <CartItem>[].obs;
  final RxBool loadingProducts = true.obs;
  final RxString search = ''.obs;

  static const double deliveryFee = 5.0;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    _bindCart();
  }

  Future<void> loadProducts() async {
    loadingProducts.value = true;
    try {
      products.value = await ContentRepository.to.getProducts();
    } catch (_) {
      products.clear();
    }
    loadingProducts.value = false;
  }

  void _bindCart() {
    cart.bindStream(UserRepository.to.cartStream());
  }

  List<Product> get filteredProducts {
    final q = search.value.trim().toLowerCase();
    if (q.isEmpty) return products;
    return products
        .where((p) =>
            p.title.toLowerCase().contains(q) ||
            p.shortDesc.toLowerCase().contains(q))
        .toList();
  }

  double get itemsTotal =>
      cart.fold(0.0, (sum, item) => sum + item.lineTotal);

  double get total => cart.isEmpty ? 0 : itemsTotal + deliveryFee;

  int get cartCount => cart.fold(0, (sum, item) => sum + item.quantity);

  Future<void> addToCart(Product product) =>
      UserRepository.to.addToCart(product);

  Future<void> increment(CartItem item) =>
      UserRepository.to.setCartQuantity(item.productId, item.quantity + 1);

  Future<void> decrement(CartItem item) =>
      UserRepository.to.setCartQuantity(item.productId, item.quantity - 1);

  Future<void> remove(CartItem item) =>
      UserRepository.to.removeFromCart(item.productId);

  Future<void> clearCartAfterOrder() => UserRepository.to.clearCart();
}
