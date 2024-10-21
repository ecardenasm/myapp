import 'package:hive/hive.dart';
import 'package:myapp/core/entity/product.dart';

class DatabaseCampusHive {
  static const String cartBoxName = 'cartBox';

  Future<Box<Product>> _openBox() async {
    return await Hive.openBox<Product>(cartBoxName);
  }

  Future<void> insertProduct(Product product) async {
    final box = await _openBox();
    await box.put(product.id, product);
  }

  Future<List<Product>> getAllProducts() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> deleteProduct(String productId) async {
    final box = await _openBox();
    await box.delete(productId);
  }

  Future<void> updateProduct(Product product) async {
    await insertProduct(product);
  }
}
