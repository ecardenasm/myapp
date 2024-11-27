import 'package:flutter/material.dart';
import 'package:myapp/core/entity/product.dart';
import 'package:myapp/core/repository/cart_repository.dart';
import 'package:myapp/core/usecase/Cart_Product_Firebase.dart';
import 'package:myapp/core/usecase/Cart_Product_Hive.dart';
import 'package:myapp/service/auth_service.dart';
import 'cart_pages.dart';
import '../widgets/market_grid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDetailsPages extends StatefulWidget {
  const ProductDetailsPages({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailsPages> createState() => _ProductDetailsPagesState();
}

class _ProductDetailsPagesState extends State<ProductDetailsPages> {
  late CartRepository _cartRepository;
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(); // Inicializa AuthService
    User? user = FirebaseAuth.instance.currentUser; // Usuario autenticado
    if (user != null) {
      _cartRepository = CartProductFirebase(user.uid);
    } else {
      _cartRepository = CartProductHive();
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Detalles del Producto'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: Image.network(
              product.imageUrl,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
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
          const SizedBox(height: 16),
          ElevatedButton(
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
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPages(
                    cartRepository: _cartRepository,
                    authService: _authService, // Pasar AuthService
                  ),
                ),
              );
            },
            child: const Text('Ver Carrito'),
          ),
          const SizedBox(height: 16),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
          const SizedBox(height: 16),
          const Text(
            'Productos relacionados',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // Envolvemos MarketGrid en un Container para evitar problemas con el ListView
          Container(
            height: 300, // Altura fija para evitar errores
            child: MarketGrid(
              addToCart: (relatedProduct) async {
                await _cartRepository.addProductToCart(relatedProduct);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Producto agregado al carrito desde la grilla'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              selectedCategory:
                  product.category, // Filtra por la categoría del producto
            ),
          ),
        ],
      ),
    );
  }
}
