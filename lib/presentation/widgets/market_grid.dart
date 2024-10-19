import 'package:flutter/material.dart';
import 'package:myapp/core/entity/product.dart';
import 'package:myapp/core/repository/product_repository.dart';
import 'product_card.dart';

class MarketGrid extends StatefulWidget {
  const MarketGrid({super.key, required this.addToCart}); // Acepta la función addToCart

  final Function(Product) addToCart; // Definimos el tipo de la función

  @override
  _MarketGridState createState() => _MarketGridState();
}

class _MarketGridState extends State<MarketGrid> {
  List<Product> products = [];
  final ProductRepository _productRepository = ProductRepository();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      List<Product> fetchedProducts = await _productRepository.getAllProducts();
      setState(() {
        products = fetchedProducts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar productos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (products.isEmpty) {
      return const Center(child: Text('No hay productos disponibles.'));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        // Aquí pasamos la función addToCart a ProductCard
        return ProductCard(
          product: products[index],
          addToCart: widget.addToCart, // Pasamos addToCart a ProductCard
        );
      },
    );
  }
}

