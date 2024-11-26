import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/core/entity/product.dart';
import 'package:myapp/core/repository/cart_repository.dart';

class CartProductFirebase implements CartRepository {
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CartProductFirebase(this.userId);

  // Referencia a la subcolección del carrito dentro del documento del usuario
  CollectionReference get _cartRef =>
      _firestore.collection('usuario').doc(userId).collection('cart');

  @override
  Future<void> addProductToCart(Product product) async {
    DocumentSnapshot existingItem = await _cartRef.doc(product.id).get();

    if (existingItem.exists) {
      int newQuantity = existingItem['quantity'] + 1;
      await _cartRef.doc(product.id).update({'quantity': newQuantity});
    } else {
      await _cartRef.doc(product.id).set({
        'productId': product.id,
        'name': product.name,
        'brand': product.brand,
        'image': product.imageUrl,
        'price': product.price,
        'quantity': 1,
      });
    }
  }

  @override
  Future<List<Product>> getCartItems() async {
    QuerySnapshot snapshot = await _cartRef.get();
    return snapshot.docs.map((doc) {
      return Product(
        id: doc['productId'],
        name: doc['name'],
        price: doc['price'],
        brand: doc['brand'],
        imageUrl: doc['image'],
        quantity: doc['quantity'],
      );
    }).toList();
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

  @override
  Future<void> checkout() async {
    QuerySnapshot snapshot = await _cartRef.get();
    if (snapshot.docs.isEmpty) {
      throw Exception('El carrito está vacío.');
    }

    // Procesar la compra
    CollectionReference ordersRef =
        _firestore.collection('usuario').doc(userId).collection('orders');

    await ordersRef.add({
      'timestamp': FieldValue.serverTimestamp(),
      'items': snapshot.docs.map((doc) {
        return {
          'productId': doc['productId'],
          'name': doc['name'],
          'price': doc['price'],
          'quantity': doc['quantity'],
        };
      }).toList(),
    });

    // Vaciar el carrito después de procesar la compra
    await clearCart();
  }
}
