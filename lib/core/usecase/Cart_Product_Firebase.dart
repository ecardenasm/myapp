import 'package:myapp/core/repository/cart_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/core/entity/product.dart';

class CartProductFirebase implements CartRepository{
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CartProductFirebase(this.userId);

  // Referencia a la subcolección del carrito dentro del documento del usuario
  CollectionReference get _cartRef =>
      _firestore.collection('usuario').doc(userId).collection('cart');
  @override
  Future<void> addProductToCart(Product product) async {
    // Verificar si el producto ya está en el carrito
    DocumentSnapshot existingItem = await _cartRef.doc(product.id).get();

    if (existingItem.exists) {
      // Si el producto ya existe, actualizar la cantidad
      int newQuantity = existingItem['quantity'] + 1;
      await _cartRef.doc(product.id).update({'quantity': newQuantity});
    } else {
      // Si el producto no existe, agregarlo al carrito
      await _cartRef.doc(product.id).set({
        'productId': product.id,
        'name': product.name, // Puedes agregar otros atributos si lo necesitas
        'brand': product.brand,
        'image': product.imageUrl,
        'price': product.price,
        'quantity': 1,
      });
    }
  }
  @override
  Future<List<Product>> getCartItems() async {
    // Obtener los items del carrito
    QuerySnapshot snapshot = await _cartRef.get();
    List<Product> cartItems = [];

    for (var doc in snapshot.docs) {
      String productId = doc['productId'];
      String name = doc['name'];
      double price = doc['price'];
      String brand = doc['brand'];
      String imageUrl = doc['image'];
      int quantity = doc['quantity'];

      Product product = Product(
          id: productId,
          name: name,
          price: price,
          brand: brand,
          imageUrl: imageUrl,
          quantity: quantity);
      cartItems.add(product);
    }

    return cartItems;
  }

  @override
  Future<bool> hasItems() async {
    QuerySnapshot snapshot = await _cartRef.get();
    return snapshot.docs.isNotEmpty;
  }

  @override
  Future<void> removeProductFromCart(String productId) async {
    await _cartRef.doc(productId).delete();
  }

  @override
  Future<void> clearCart() async {
    WriteBatch batch = _firestore.batch();
    QuerySnapshot snapshot = await _cartRef.get();

    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}