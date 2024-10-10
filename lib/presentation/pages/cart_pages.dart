import 'package:flutter/material.dart';
import 'package:myapp/core/entity/product.dart';
import 'package:myapp/core/repository/cart_repository.dart';

class CartPages extends StatefulWidget {
  final CartRepository cartRepository;

  const CartPages({super.key, required this.cartRepository}); // Constructor que recibe el repositorio del carrito

  @override
  _CartPagesState createState() => _CartPagesState();
}

class _CartPagesState extends State<CartPages> {
  late Future<List<Product>> _cartItemsFuture;

  @override
  void initState() {
    super.initState();
    _cartItemsFuture = widget.cartRepository.getCartItems(); // Inicializa la lista de productos del carrito
  }

  Future<void> _removeProduct(String productId) async {
    await widget.cartRepository.removeProductFromCart(productId);
    setState(() {
      _cartItemsFuture = widget.cartRepository.getCartItems(); // Actualiza la lista de productos
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Producto eliminado del carrito')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: FutureBuilder<List<Product>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          // Estado de carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Manejo de errores
          else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar el carrito: ${snapshot.error}'));
          }
          // Verificación de lista vacía
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('El carrito está vacío.'));
          }
          // Lista de productos en el carrito
          else {
            final cartItems = snapshot.data!;
            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(product.name),
                      ),
                      // Burbuja verde que muestra la cantidad
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${product.quantity}', // Asegúrate de que `quantity` esté en tu clase Product
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text('Precio: \$${product.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_shopping_cart),
                    onPressed: () {
                      // Lógica para eliminar el producto del carrito
                      _removeProduct(product.id); // Llama a la función para eliminar
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
