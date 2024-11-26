import 'package:flutter/material.dart';
import 'package:myapp/core/entity/product.dart';
import 'package:myapp/core/repository/cart_repository.dart';
import 'package:myapp/presentation/pages/whatsapp_page.dart';

class CartPages extends StatefulWidget {
  final CartRepository cartRepository;

  const CartPages({super.key, required this.cartRepository});

  @override
  _CartPagesState createState() => _CartPagesState();
}

class _CartPagesState extends State<CartPages> {
  late Future<List<Product>> _cartItemsFuture;

  @override
  void initState() {
    super.initState();
    _cartItemsFuture = widget.cartRepository.getCartItems();
  }

  Future<void> _removeProduct(String productId) async {
    await widget.cartRepository.removeProductFromCart(productId);
    setState(() {
      _cartItemsFuture = widget.cartRepository.getCartItems();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto eliminado del carrito')),
    );
  }

  Future<void> _checkout() async {
    try {
      await widget.cartRepository.checkout(); // Método del repositorio para procesar la compra
      setState(() {
        _cartItemsFuture = widget.cartRepository.getCartItems();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compra realizada con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al realizar la compra: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: FutureBuilder<List<Product>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar el carrito: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('El carrito está vacío.'));
          } else {
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
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${product.quantity}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text('Precio: \$${product.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_shopping_cart),
                    onPressed: () {
                      _removeProduct(product.id);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => WhatsAppContactPage(phoneNumber: '573128370891'),
            ),
          );

            _checkout();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          child: const Text(
            'Realizar compra',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
