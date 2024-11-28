import 'package:flutter/material.dart';
import 'package:myapp/presentation/widgets/market_grid.dart';
import 'package:myapp/core/entity/product.dart';

class CategoryPages extends StatefulWidget {
  const CategoryPages(
      {super.key, required this.addToCart}); // Añadido el parámetro addToCart
  final Function(Product) addToCart; // Define el tipo de la función

  @override
  _CategoryPagesState createState() => _CategoryPagesState();
}

class _CategoryPagesState extends State<CategoryPages> {
  final List<String> categories = ['Comida', 'Bebida', 'Papelería', 'Otros'];
  String selectedCategory = 'Todos'; // Valor por defecto

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        color: Colors.greenAccent.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Selecciona una categoría',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Barra de navegación horizontal para las categorías
            Container(
              height: 50, // Altura más pequeña para hacer la barra más compacta
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = categories[index];
                      });
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16), // Bordes redondeados
                      ),
                      margin: const EdgeInsets.only(
                          right: 12.0), // Espaciado entre tarjetas
                      color: selectedCategory == categories[index]
                          ? Colors.greenAccent
                          : Colors.white,
                      child: Container(
                        width: 80, // Ancho reducido para las tarjetas
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: selectedCategory == categories[index]
                              ? Colors.greenAccent
                              : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              fontSize: 14, // Tamaño de fuente ajustado
                              fontWeight: FontWeight.bold,
                              color: selectedCategory == categories[index]
                                  ? Colors.white
                                  : Colors.greenAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Grilla de productos con la categoría seleccionada
            Expanded(
              child: MarketGrid(
                addToCart: widget
                    .addToCart, // Se pasa correctamente la función addToCart
                selectedCategory:
                    selectedCategory, // Se pasa la categoría seleccionada
              ),
            ),
          ],
        ),
      ),
    );
  }
}
