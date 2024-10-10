import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/core/entity/product.dart';
import 'package:myapp/core/repository/product_repository.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _nameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _priceController = TextEditingController();

  final ProductRepository _productRepository = ProductRepository();

  Future<void> agregarProducto() async {
    String name = _nameController.text.trim();
    String imageUrl = _imageUrlController.text.trim();
    double price = double.tryParse(_priceController.text.trim()) ?? 0.0;

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Debe iniciar sesión para agregar productos.'),
      ));
      return;
    }

    // Asignar el brand al nombre del usuario
    String brand = user.displayName ?? 'Desconocido';

    // Crear una instancia del producto sin ID
    Product product = Product(
      id: '', // ID temporal vacío
      name: name,
      imageUrl: imageUrl,
      price: price,
      brand: brand,  // El brand es el nombre del usuario
    );

    try {
      // Guardar el producto en Firebase y obtener el ID del documento
      String newProductId = await _productRepository.addProduct(product);

      // Asignar el ID generado por Firebase al producto
      product = Product(
        id: newProductId,  // El ID generado por Firebase
        name: name,
        imageUrl: imageUrl,
        price: price,
        brand: brand,
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Producto agregado exitosamente.'),
      ));

      // Redirigir a la página principal después de agregar el producto
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al agregar producto: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre del Producto'),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'URL de la Imagen'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: agregarProducto,
              child: const Text('Agregar Producto'),
            ),
          ],
        ),
      ),
    );
  }
}

