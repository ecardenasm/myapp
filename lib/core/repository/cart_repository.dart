import 'package:myapp/core/entity/product.dart';

abstract class CartRepository {
  Future<void> addProductToCart(Product product);
  Future<List<Product>> getCartItems();
  Future<bool> hasItems();
  Future<void> removeProductFromCart(String productId);
  Future<void> clearCart();
  Future<void> checkout();

  // Método adicional para eliminar productos de un proveedor específico
  Future<void> removeProductsBySupplier(String supplierPhoneNumber);
}
