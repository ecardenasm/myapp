import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart'; // Necesario para saber si es web

class WhatsAppContactPage extends StatefulWidget {
  final String phoneNumber; // Número de WhatsApp al que se enviará el mensaje

  const WhatsAppContactPage({super.key, required this.phoneNumber});

  @override
  State<WhatsAppContactPage> createState() => _WhatsAppContactPageState();
}

class _WhatsAppContactPageState extends State<WhatsAppContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  Future<void> _redirectToWhatsApp() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text;
      final email = _emailController.text;
      final message = _messageController.text;

      // Mensaje personalizado para WhatsApp
      final whatsappMessage =
          'Hola, mi nombre es $name. Mi correo es $email.\n\n$message';

      // Generar enlace de WhatsApp
      final whatsappUrl =
          'https://wa.me/${widget.phoneNumber}?text=${Uri.encodeComponent(whatsappMessage)}';

      final uri = Uri.parse(whatsappUrl);

      try {
        if (kIsWeb) {
          // Si es Web, abrir en una nueva pestaña
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          // Para dispositivos móviles
          if (await canLaunchUrl(uri)) {
            await launchUrl(
              uri,
              mode: LaunchMode.externalApplication, // Asegura soporte móvil
            );
          } else {
            throw Exception('No se pudo abrir el enlace');
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacto por WhatsApp')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu nombre.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu correo.';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor, ingresa un correo válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Mensaje',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un mensaje.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _redirectToWhatsApp,
                child: const Text('Enviar a WhatsApp'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
