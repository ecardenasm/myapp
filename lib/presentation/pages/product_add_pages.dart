import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/core/entity/product.dart';
import 'package:myapp/core/repository/product_repository.dart';
import 'package:myapp/core/repository/user_repository.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _nameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _priceController = TextEditingController();

  final List<String> _categories = ['Comida', 'Bebida', 'Papelería', 'Otros'];

  final ProductRepository _productRepository = ProductRepository();
  final UserRepository _userRepository = UserRepository();

  Future<void> agregarProducto() async {
    String name = _nameController.text.trim();
    String imageUrl = _imageUrlController.text.trim();
    double price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    String category = _selectedCategory ?? ''; // Usa la categoría seleccionada

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Debe iniciar sesión para agregar productos.'),
      ));
      return;
    }

    // Obtener los detalles del usuario desde Firestore
    try {
      final usuarioDoc = await _userRepository.firestore
          .collection('usuarios')
          .doc(user.uid)
          .get();
      if (usuarioDoc.exists) {
        // Extraer teléfono y nombre desde Firestore
        String supplierPhoneNumber =
            usuarioDoc['telefono'] ?? ''; // El teléfono está en Firestore
        print("Número de teléfono del proveedor: $supplierPhoneNumber");

        // Asignar el brand al nombre del usuario
        String brand = user.displayName ?? 'Desconocido';

        // Crear una instancia del producto sin ID, el ID lo asignaremos después
        Product product = Product(
          id: '', // ID temporal vacío
          name: name,
          imageUrl: imageUrl,
          price: price,
          brand: brand,
          category: category,
          supplierPhoneNumber:
              supplierPhoneNumber, // Número de teléfono del proveedor
          quantity: 1, // Asignar la cantidad como 1 de forma predeterminada
        );

        print(
            'Guardando producto: ${product.toMap()}'); // Verifica los datos que se están guardando

        try {
          // Guardar el producto en Firebase y obtener el ID del documento
          String newProductId = await _productRepository.addProduct(product);

          // Actualizar el producto con el ID generado por Firebase
          product = product.copyWith(id: newProductId);

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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Usuario no encontrado en la base de datos.'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al obtener los datos del usuario: $e'),
      ));
    }
  }

  String? _selectedCategory; // Nueva variable para la categoría seleccionada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Nombre del producto
              TextField(
                controller: _nameController,
                decoration:
                    const InputDecoration(labelText: 'Nombre del Producto'),
              ),
              const SizedBox(height: 10),

              // Imagen URL con previsualización
              TextField(
                controller: _imageUrlController,
                decoration:
                    const InputDecoration(labelText: 'URL de la Imagen'),
                keyboardType: TextInputType.url,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),
              if (_imageUrlController.text.isNotEmpty)
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(_imageUrlController.text),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 10),

              // Precio
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              // Categoría
              DropdownButton<String>(
                hint: const Text('Selecciona una categoría'),
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedCategory =
                        value; // Actualiza la categoría seleccionada
                  });
                },
              ),
              const SizedBox(height: 20),

              // Botón para agregar producto
              ElevatedButton(
                onPressed: agregarProducto,
                child: const Text('Agregar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
