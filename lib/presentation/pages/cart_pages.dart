import 'package:flutter/material.dart';
import 'package:myapp/core/entity/product.dart';
import 'package:myapp/core/entity/user.dart';
import 'package:myapp/core/repository/cart_repository.dart';
import 'package:myapp/presentation/pages/whatsapp_page.dart';
import 'package:myapp/service/auth_service.dart';
import 'package:intl/intl.dart'; // Importa intl para formatear la moneda

class CartPages extends StatefulWidget {
  final CartRepository cartRepository;
  final AuthService authService;

  const CartPages({
    super.key,
    required this.cartRepository,
    required this.authService,
  });

  @override
  _CartPagesState createState() => _CartPagesState();
}

class _CartPagesState extends State<CartPages> {
  late Future<List<Product>> _cartItemsFuture;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() {
    _cartItemsFuture = widget.cartRepository.getCartItems();
  }

  Future<bool> isUserLoggedIn() async {
    return await widget.authService.isUserLoggedIn();
  }

  Future<Usuario?> getUserDetails() async {
    return await widget.authService.getCurrentUser();
  }

  Map<String, List<Product>> _groupProductsBySupplier(List<Product> products) {
    final groupedProducts = <String, List<Product>>{};
    for (var product in products) {
      final supplierPhoneNumber = product.supplierPhoneNumber;
      if (!groupedProducts.containsKey(supplierPhoneNumber)) {
        groupedProducts[supplierPhoneNumber] = [];
      }
      groupedProducts[supplierPhoneNumber]!.add(product);
    }
    return groupedProducts;
  }

  String _formatCurrency(double value) {
    final format = NumberFormat.simpleCurrency(
        locale: 'es_CO'); // Formatea a moneda colombiana
    return format.format(value);
  }

  Future<void> _sendOrdersToWhatsApp(List<Product> products) async {
    final groupedProducts = _groupProductsBySupplier(products);
    final userLoggedIn = await isUserLoggedIn();
    final userDetails = userLoggedIn ? await getUserDetails() : null;

    for (var supplierPhoneNumber in groupedProducts.keys) {
      if (supplierPhoneNumber.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Proveedor sin número de teléfono')),
        );
        continue;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Número de teléfono del proveedor: $supplierPhoneNumber'),
        ),
      );

      final supplierProducts = groupedProducts[supplierPhoneNumber]!;
      final total = supplierProducts.fold<double>(
          0, (sum, product) => sum + (product.price * product.quantity));

      final productDetails = supplierProducts
          .map((p) =>
              '- ${p.name} (x${p.quantity}): ${_formatCurrency(p.price * p.quantity)}') // Formateo de precio
          .join('\n');

      final message = userLoggedIn && userDetails != null
          ? 'Pedido:\n\n$productDetails\n\nTotal: ${_formatCurrency(total)}\n\nUsuario: ${userDetails.nombre} Y telefono (${supplierPhoneNumber}), (${userDetails.correo})'
          : 'Pedido:\n\n$productDetails\n\nTotal: ${_formatCurrency(total)}';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WhatsAppContactPage(
            phoneNumber: supplierPhoneNumber,
            prefilledMessage: message,
          ),
        ),
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
                  title: Text(product.name),
                  subtitle: Text(
                      'Precio: ${_formatCurrency(product.price)}'), // Precio formateado
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_shopping_cart),
                    onPressed: () async {
                      await widget.cartRepository
                          .removeProductFromCart(product.id);
                      // Actualiza los productos en el carrito al eliminar uno
                      setState(() {
                        _loadCartItems(); // Cargar nuevamente el carrito
                      });
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
          onPressed: () async {
            final cartItems = await widget.cartRepository.getCartItems();
            if (cartItems.isNotEmpty) {
              await _sendOrdersToWhatsApp(cartItems);
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          child: const Text(
            'Enviar pedidos por WhatsApp',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
