import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/presentation/pages/product_add_pages.dart';
import 'edit_profile_pages.dart'; // Importa la página de edición de perfil

class ProfilePages extends StatelessWidget {
  const ProfilePages({super.key});

  Future<Map<String, dynamic>?> obtenerDatosUsuario() async {
    User? usuario = FirebaseAuth.instance.currentUser;

    if (usuario != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('usuarios').doc(usuario.uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: obtenerDatosUsuario(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No se encontró información del usuario.'));
        }

        final userData = snapshot.data!;

        return Center(      
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    userData['photoUrl'] ?? '', // Asegúrate de que tengas un campo para la URL de la foto
                    width: 100,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, size: 100); // Icono por defecto si hay un error
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Nombre:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  userData['nombre'] ?? 'Nombre no disponible',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Teléfono:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  userData['telefono'] ?? 'Teléfono no disponible',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 40), // Espacio antes del botón
                
                // Botones para editar perfil y agregar producto
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Espaciado entre botones
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navegar a la página de editar perfil
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(userData: userData),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar Perfil'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navegar a la página de agregar producto
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AddProductPage()),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar Producto'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
