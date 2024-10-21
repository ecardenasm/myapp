import 'package:myapp/core/repository/cart_repository.dart';
import 'package:myapp/core/entity/product.dart';
import 'package:myapp/data/datasource/DatabaseCampusHive.dart';

class CartProductHive implements CartRepository {
  final DatabaseCampusHive db;

  CartProductHive() : db = DatabaseCampusHive();

  @override
  Future<void> addProductToCart(Product product) async {
    await db.insertProduct(product);
  }

  @override
  Future<List<Product>> getCartItems() async {
    return await db.getAllProducts();
  }

  @override
  Future<bool> hasItems() async {
    final cartItems = await db.getAllProducts();
    return cartItems.isNotEmpty;
  }

  @override
  Future<void> removeProductFromCart(String productId) async {
    await db.deleteProduct(productId);
  }

  @override
  Future<void> clearCart() async {
    final cartItems = await db.getAllProducts();
    for (var item in cartItems) {
      await db.deleteProduct(item.id);
    }
  }
}
