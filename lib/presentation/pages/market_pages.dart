import 'package:flutter/material.dart';
import '../widgets/market_grid.dart';
import '../../core/entity/product.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key, required this.addToCart}); // Añadido el parámetro addToCart

  final Function(Product) addToCart; // Define el tipo de la función

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: MarketGrid(
        addToCart: addToCart,
        selectedCategory: 'Todos',
        ), // Pasamos addToCart a MarketGrid
    );
  }
}

