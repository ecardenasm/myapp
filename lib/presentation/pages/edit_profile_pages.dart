import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfilePage({Key? key, required this.userData}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nombreController;
  late TextEditingController _telefonoController;
  late TextEditingController _imagenUrlController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.userData['nombre']);
    _telefonoController = TextEditingController(text: widget.userData['telefono']);
    _imagenUrlController = TextEditingController(text: widget.userData['photoUrl']);
  }

  Future<void> _actualizarPerfil() async {
    User? usuario = _auth.currentUser;
    if (usuario != null) {
      await FirebaseFirestore.instance.collection('usuarios').doc(usuario.uid).update({
        'nombre': _nombreController.text,
        'telefono': _telefonoController.text,
        'photoUrl': _imagenUrlController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado exitosamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _telefonoController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
            ),
            TextField(
              controller: _imagenUrlController,
              decoration: const InputDecoration(labelText: 'URL de la Imagen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _actualizarPerfil,
              child: const Text('Guardar Cambios'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
