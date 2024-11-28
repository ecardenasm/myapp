import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myapp/core/repository/cart_repository.dart'; // Asegúrate de importar el repositorio

class WhatsAppContactPage extends StatefulWidget {
  final String phoneNumber;
  final String prefilledMessage;
  final CartRepository cartRepository; // Añadir el repositorio aquí

  const WhatsAppContactPage({
    super.key,
    required this.phoneNumber,
    required this.prefilledMessage,
    required this.cartRepository, // Pasar el repositorio como parámetro
  });

  @override
  _WhatsAppContactPageState createState() => _WhatsAppContactPageState();
}

class _WhatsAppContactPageState extends State<WhatsAppContactPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String? _selectedBlock; // Variable para almacenar la ubicación seleccionada

  // Lista de bloques disponibles
  final List<String> _blocks = ['A', 'B', 'C', 'D', 'E', 'F', 'H', 'I', 'P'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_formKey.currentState?.validate() ?? false) {
      final userName = _nameController.text;
      final userDescription = _descriptionController.text;
      final userLocation = _selectedBlock != null
          ? 'Estoy cerca del bloque $_selectedBlock'
          : '';

      final updatedMessage = widget.prefilledMessage +
          '\n\nNombre: $userName\nDescripción: $userDescription\n${userLocation}';

      final whatsappUrl =
          'https://wa.me/${widget.phoneNumber}?text=${Uri.encodeComponent(updatedMessage)}';

      final uri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        // Llamar a la función para eliminar productos del carrito después de enviar el mensaje
        _removeProductsFromCart();
      } else {
        throw Exception('No se pudo abrir WhatsApp');
      }
    }
  }

  void _removeProductsFromCart() async {
    // Aquí llamamos al repositorio para eliminar los productos del carrito
    await widget.cartRepository.removeProductsBySupplier(widget.phoneNumber);

    // Regresar a la página anterior (Carrito)
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enviando pedido')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de quien pide',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción del usuario',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una breve descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Dropdown para seleccionar la ubicación (bloque)
              DropdownButtonFormField<String>(
                value: _selectedBlock,
                hint: const Text('Selecciona tu ubicación'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBlock = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecciona un bloque';
                  }
                  return null;
                },
                items: _blocks.map((block) {
                  return DropdownMenuItem<String>(
                    value: block,
                    child: Text('Bloque $block'),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendMessage,
                child: const Text('Enviar pedido'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
