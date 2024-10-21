import 'package:flutter/material.dart';
import 'package:myapp/core/entity/product.dart';
import 'package:myapp/core/repository/product_repository.dart';
import 'product_card.dart';

class MarketGrid extends StatefulWidget {
  const MarketGrid({super.key, required this.addToCart, required this.selectedCategory});

  final Function(Product) addToCart;
  final String selectedCategory;

  @override
  _MarketGridState createState() => _MarketGridState();
}

class _MarketGridState extends State<MarketGrid> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
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
        _filterProducts(); // Filtra los productos de acuerdo a la categoría seleccionada
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

  void _filterProducts() {
    if (widget.selectedCategory == 'Todos') {
      filteredProducts = products;
    } else {
      filteredProducts = products.where((product) => product.category == widget.selectedCategory).toList();
    }
  }

  @override
  void didUpdateWidget(MarketGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      _filterProducts(); // Actualiza los productos filtrados si cambia la categoría
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredProducts.isEmpty) {
      return const Center(child: Text('No hay productos disponibles para esta categoría.'));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.75,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        return ProductCard(
          product: filteredProducts[index],
          addToCart: widget.addToCart,
        );
      },
    );
  }
}
