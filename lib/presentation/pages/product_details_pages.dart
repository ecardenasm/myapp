import 'package:flutter/material.dart';
import 'package:myapp/core/entity/product.dart';
import 'package:myapp/core/repository/cart_repository.dart';
import 'package:myapp/core/usecase/Cart_Product_Firebase.dart';
import 'cart_pages.dart';
import '../widgets/market_grid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/core/usecase/Cart_Product_Hive.dart';

class ProductDetailsPages extends StatefulWidget {
  const ProductDetailsPages({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailsPages> createState() => _ProductDetailsPagesState();
}

class _ProductDetailsPagesState extends State<ProductDetailsPages> {
  late CartRepository _cartRepository;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser; // Obtener el usuario autenticado
    if (user != null) {
      _cartRepository = CartProductFirebase(user.uid); // Inicializa CartRepository con el userId del usuario autenticado
    } else {
      _cartRepository = CartProductHive(); // Inicializa CartRepository con Hive si no hay usuario autenticado
    }
  }

  @override
  Widget build(BuildContext context) {
    var product = widget.product;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(product.imageUrl, height: 200, fit: BoxFit.cover),
                const SizedBox(height: 16),
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Precio: \$${product.price}',
                  style: const TextStyle(fontSize: 18, color: Colors.green),
                ),
                const SizedBox(height: 8),
                Text(
                  'Marca/Tienda: ${product.brand}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await _cartRepository.addProductToCart(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Producto agregado al carrito'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Agregar al carrito'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPages(cartRepository: _cartRepository,),
                ),
              );
            },
            child: const Text('Ver Carrito'),
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
          Expanded(
            child: MarketGrid(addToCart: (product) async {
              await _cartRepository.addProductToCart(product); // Agrega el producto al carrito
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Producto agregado al carrito desde la grilla'),
                  duration: Duration(seconds: 2),
                ),
              );
              setState(() {}); // Forzar la actualización de la interfaz
            }, selectedCategory: 'Todos',),
          ),
        ],
      ),
    );
  }
}
