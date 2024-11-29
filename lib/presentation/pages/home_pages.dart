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
import 'package:myapp/service/auth_service.dart';
import 'category_pages.dart';
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
  late final AuthService _authService; // Nueva instancia de AuthService
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser; // Usuario autenticado
    _authService = AuthService(); // Inicializar AuthService
    if (user != null) {
      _cartRepository =
          CartProductFirebase(user.uid); // Firebase si hay usuario autenticado
    } else {
      _cartRepository = CartProductHive(); // Hive si no hay usuario autenticado
    }
  }

  // Método para agregar al carrito
  void _addToCart(Product product) async {
    await _cartRepository.addProductToCart(product);

    // Mostrar mensaje con la interpolación de la variable supplierPhoneNumber
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Producto agregado al carrito, Teléfono: ${product.supplierPhoneNumber}'),
      ),
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
      CategoryPages(addToCart: _addToCart),
      const ProfilePages(),
      CartPages(
        cartRepository: _cartRepository,
        authService: _authService,
      ),
    ];

    void _searchProducts(String query) {
      // Lógica adicional si quieres manejar resultados directamente desde el Home
    }

    return Scaffold(
      body: Column(
        children: [
          BuildSearch(onSearch: _searchProducts),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: FutureBuilder<bool>(
        future: _cartRepository.hasItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          } else if (snapshot.hasError || !(snapshot.data ?? false)) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton(
            onPressed: () {
              setState(() {
                _currentIndex = 3;
              });
            },
            backgroundColor: Colors.greenAccent,
            child: const Icon(Icons.shopping_cart),
          );
        },
      ),
    );
  }
}
