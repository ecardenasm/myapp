import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/core/entity/product.dart';
import 'package:myapp/core/repository/cart_repository.dart';

class CartProductFirebase implements CartRepository {
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CartProductFirebase(this.userId);

  // Referencia a la subcolección del carrito del usuario
  CollectionReference get _cartRef =>
      _firestore.collection('usuarios').doc(userId).collection('carrito');

  @override
  Future<void> addProductToCart(Product product) async {
    try {
      DocumentSnapshot existingItem = await _cartRef.doc(product.id).get();

      if (existingItem.exists) {
        // Incrementar la cantidad si el producto ya está en el carrito
        int currentQuantity =
            existingItem['quantity'] ?? 0; // Evitar valores nulos
        int newQuantity = currentQuantity + product.quantity;
        await _cartRef.doc(product.id).update({'quantity': newQuantity});
      } else {
        // Agregar el producto como nuevo
        await _cartRef.doc(product.id).set({
          'productId': product.id,
          'name': product.name ?? 'Nombre desconocido', // Validación de nulos
          'brand': product.brand ?? 'Marca desconocida', // Validación de nulos
          'imageUrl': product.imageUrl ??
              '', // Usar valor vacío si la URL de la imagen es nula
          'price':
              product.price ?? 0.0, // Asegurarse de que el precio no sea nulo
          'quantity':
              product.quantity ?? 1, // Valor predeterminado para cantidad
          'category':
              product.category ?? 'Sin categoría', // Valor predeterminado
          'telefono': product.supplierPhoneNumber ??
              'Sin teléfono', // Valor predeterminado
        });
      }
    } catch (e) {
      throw Exception('Error al agregar producto al carrito: $e');
    }
  }

  @override
  Future<List<Product>> getCartItems() async {
    try {
      QuerySnapshot snapshot = await _cartRef.get();

      // Mapea los documentos a productos
      return snapshot.docs.map((doc) {
        try {
          // Validar si los datos del documento están completos antes de mapear
          var data = doc.data() as Map<String, dynamic>;

          // Verificar campos clave antes de crear el producto
          if (data['productId'] == null ||
              data['name'] == null ||
              data['price'] == null) {
            throw Exception(
                'Datos incompletos en el documento con ID: ${doc.id}');
          }

          // Usar valores predeterminados en caso de que falten campos opcionales
          String name = data['name'] ?? 'Nombre desconocido';
          String brand = data['brand'] ?? 'Marca desconocida';
          String imageUrl = data['imageUrl'] ?? '';
          double price = data['price'] ?? 0.0;
          int quantity = data['quantity'] ?? 1;
          String category = data['category'] ?? 'Sin categoría';
          String supplierPhoneNumber = data['telefono'] ?? 'Sin teléfono';

          return Product(
            id: doc.id,
            name: name,
            brand: brand,
            imageUrl: imageUrl,
            price: price,
            quantity: quantity,
            category: category,
            supplierPhoneNumber: supplierPhoneNumber,
          );
        } catch (e) {
          print('Error al mapear el producto con id ${doc.id}: $e');
          rethrow;
        }
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener productos del carrito: $e');
    }
  }

  @override
  Future<bool> hasItems() async {
    try {
      QuerySnapshot snapshot = await _cartRef.limit(1).get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Error al verificar si el carrito tiene productos: $e');
    }
  }

  @override
  Future<void> removeProductFromCart(String productId) async {
    try {
      await _cartRef.doc(productId).delete();
    } catch (e) {
      throw Exception('Error al eliminar producto del carrito: $e');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      WriteBatch batch = _firestore.batch();
      QuerySnapshot snapshot = await _cartRef.get();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Error al vaciar el carrito: $e');
    }
  }

  @override
  Future<void> checkout() async {
    try {
      QuerySnapshot snapshot = await _cartRef.get();

      if (snapshot.docs.isEmpty) {
        throw Exception('El carrito está vacío.');
      }

      // Crear pedido en la subcolección "pedidos"
      CollectionReference ordersRef =
          _firestore.collection('usuarios').doc(userId).collection('pedidos');

      await ordersRef.add({
        'timestamp': FieldValue.serverTimestamp(),
        'productos': snapshot.docs.map((doc) {
          return {
            'productId': doc['productId'],
            'name': doc['name'],
            'price': doc['price'],
            'quantity': doc['quantity'],
            'imageUrl': doc['imageUrl'],
            'telefono': doc['telefono']
          };
        }).toList(),
        'estado': 'pendiente',
      });

      // Vaciar el carrito después del checkout
      await clearCart();
    } catch (e) {
      throw Exception('Error al procesar el checkout: $e');
    }
  }
}
