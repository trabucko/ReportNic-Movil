import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> createAccount(String correo, String pass) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: correo,
        password: pass,
      );
      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'La contraseña proporcionada es demasiado débil.';
      } else if (e.code == 'email-already-in-use') {
        return 'La cuenta ya existe.';
      }
    } catch (e) {
      return 'Error al crear la cuenta: $e';
    }
    return null;
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No se encontró un usuario con ese correo electrónico.';
      } else if (e.code == 'wrong-password') {
        return 'La contraseña es incorrecta.';
      } else {
        return 'Error de autenticación: ${e.message}';
      }
    } catch (e) {
      return 'Error al iniciar sesión: $e';
    }
  }
}

class AuthState with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
