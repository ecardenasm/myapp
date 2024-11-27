import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/core/entity/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> isUserLoggedIn() async {
    return _auth.currentUser != null;
  }

  Future<Usuario?> getCurrentUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return null;

    return Usuario(
      id: currentUser.uid,
      nombre: currentUser.displayName ?? '',
      correo: currentUser.email ?? '',
      telefono: currentUser.phoneNumber ?? 'N/A', // Valor predeterminado
    );
  }
}
