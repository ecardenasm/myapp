import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/core/entity/user.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getter para FirebaseFirestore
  FirebaseFirestore get firestore => _firestore;

  Future<User?> registerUser({
    required String nombre,
    required String correo,
    required String telefono,
    required String password,
  }) async {
    try {
      // Crear usuario con Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: correo.trim(),
        password: password.trim(),
      );

      // Actualizar el perfil del usuario con el nombre
      await userCredential.user!.updateDisplayName(nombre.trim());
      await userCredential.user!.reload();

      // Crear una instancia de Usuario sin la contraseña
      Usuario nuevoUsuario = Usuario(
        id: userCredential.user!.uid,
        nombre: nombre.trim(),
        correo: correo.trim(),
        telefono: telefono.trim(),
      );

      // Guardar los datos del usuario en Firestore
      await _firestore
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .set(nuevoUsuario.toMap());

      return userCredential.user;
    } catch (e) {
      print('Error al registrar usuario: $e');
      return null;
    }
  }

  // Método adicional para obtener los datos del usuario desde Firestore
  Future<Usuario?> getUserData(String userId) async {
    try {
      // Obtener los datos del usuario desde Firestore
      DocumentSnapshot snapshot =
          await _firestore.collection('usuarios').doc(userId).get();
      if (snapshot.exists) {
        // Convertir los datos a la instancia Usuario
        return Usuario.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error al obtener los datos del usuario: $e');
      return null;
    }
  }
}
