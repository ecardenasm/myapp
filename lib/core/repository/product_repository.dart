import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/core/entity/product.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para agregar un producto y devolver el ID generado por Firebase
  Future<String> addProduct(Product product) async {
    DocumentReference docRef =
        await _firestore.collection('productos').add(product.toMap());

    // Retorna el ID del documento recién creado
    return docRef.id;
  }

  // Método para obtener todos los productos
  Future<List<Product>> getAllProducts() async {
    QuerySnapshot snapshot = await _firestore.collection('productos').get();

    return snapshot.docs.map((doc) {
      return Product.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
