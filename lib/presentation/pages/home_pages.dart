import 'package:flutter/material.dart';
import 'market_pages.dart';
import 'cart_pages.dart';
import 'profile_pages.dart';
import '../widgets/build_search.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import 'package:myapp/core/entity/product.dart';
import 'package:myapp/core/usecase/Cart_Product_Firebase.dart';
import 'package:myapp/core/repository/cart_repository.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'category_pages.dart';// Importar Firebase Auth para obtener el userId
import 'package:myapp/core/usecase/Cart_Product_Hive.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  late final CartRepository _cartRepository;
  int _currentPageIndex = 0;

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

  // Método para agregar al carrito
  void _addToCart(Product product) async {
    await _cartRepository.addProductToCart(product);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto agregado al carrito')),
    );
    setState(() {}); // Opcional, para forzar la reconstrucción si es necesario
  }

  // Método para cambiar entre pestañas
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      MarketPage(addToCart: _addToCart),
      const CategoryPages(),
      const ProfilePages(),
      CartPages(cartRepository: _cartRepository), // pasamos el repositorio
    ];

    return Scaffold(
      body: Column(
        children: [
          const BuildSearch(),
          Expanded(child: _pages[_currentPageIndex]),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: FutureBuilder<bool>(
        future: _cartRepository.hasItems(), // Llamada para verificar si hay productos en el carrito
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Muestra un indicador de carga mientras se espera
          } else if (snapshot.hasError) {
            return Container(); // Maneja el error, en este caso no mostramos el botón
          } else if (snapshot.hasData && snapshot.data == true) {
            return FloatingActionButton(
              onPressed: () {
                setState(() {
                  _currentPageIndex = 3; // Cambia a la pestaña del carrito
                });
              },
              backgroundColor: Colors.greenAccent,
              child: const Icon(Icons.shopping_cart),
            );
          } else {
            return Container(); // Si no hay productos, no muestra el botón
          }
        },
      ),
    );
  }
}

