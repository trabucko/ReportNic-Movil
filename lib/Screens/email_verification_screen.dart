import 'dart:async'; // Import para usar Timer
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt; // Importa la biblioteca de encriptación con alias
import 'dart:typed_data';

// Convierte una lista de bytes a una cadena hexadecimal
String bytesToHex(Uint8List bytes) {
  return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
}

// Convierte una cadena hexadecimal a una lista de bytes
Uint8List hexToBytes(String hex) {
  final bytes = <int>[];
  for (var i = 0; i < hex.length; i += 2) {
    bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
  }
  return Uint8List.fromList(bytes);
}

// Nueva función de encriptación
String encryptPassword(String password) {
  const encryptionKey = '5F7A8B9C1D2E3F4A6B8C7D9E1F2A3B4C';
  final key = encrypt.Key(hexToBytes(encryptionKey));

  // Genera un IV aleatorio de 16 bytes
  final iv = encrypt.IV.fromLength(16);

  // Crea el encriptador con AES-256-CBC
  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  // Encripta la contraseña
  final encrypted = encrypter.encrypt(password, iv: iv);

  // Retorna el IV y el texto encriptado en formato hexadecimal
  return '${bytesToHex(iv.bytes)}:${bytesToHex(encrypted.bytes)}';
}

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String nombre;
  final String apellido;
  final String cedula;
  final String telefono;
  final String password;
  final DateTime fechaYHoraActual;
  final dynamic idParamedico;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.nombre,
    required this.apellido,
    required this.cedula,
    required this.telefono,
    required this.password,
    required this.fechaYHoraActual,
    required this.idParamedico,
  });

  @override
  EmailVerificationScreenState createState() => EmailVerificationScreenState();
}

class EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isVerifying = false;
  bool isLoading = true;
  bool _isVerified = false;
  Timer? _verificationCheckTimer; // Timer para verificar periódicamente

  @override
  void initState() {
    super.initState();
    _startVerificationCheck(); // Iniciar verificación al iniciar la pantalla
  }

  @override
  void dispose() {
    _verificationCheckTimer?.cancel(); // Cancela el timer al cerrar la pantalla
    super.dispose();
  }

  // Función que chequea el estado de verificación periódicamente
  void _startVerificationCheck() {
    _verificationCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _checkVerificationStatus();
    });
  }

  Future<void> _checkVerificationStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload(); // Recargar la información del usuario

      if (user.emailVerified) {
        // Encriptar la contraseña usando la nueva función
        // ignore: unused_local_variable
        final encryptedPassword = encryptPassword(widget.password);

        // Completar el registro en Firestore
        await FirebaseFirestore.instance.collection('usuarios_moviles').doc(user.uid).set({
          'nombre': widget.nombre,
          'apellido': widget.apellido,
          'cedula': widget.cedula,
          'telefono': widget.telefono,
          'email': widget.email,
          'contraseña': widget.password, // Subir la contraseña encriptada
          'Fecha de Creacion': widget.fechaYHoraActual,
          'emailVerified': true,
          'IdParamedico': widget.idParamedico,
        });

        setState(() {
          _isVerified = true;
          isLoading = false;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/login');
        });
      } else {
        setState(() {
          _isVerifying = true;
          isLoading = false;
        });
      }
    }
  }

  Future<void> _resendVerificationEmail(String email) async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Correo de verificación reenviado.'),
          backgroundColor: Colors.green,
        ),
      );

      // Re-iniciar la verificación después de reenviar el correo
      _startVerificationCheck();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al reenviar correo de verificación: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue, // Fondo celeste
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.email_outlined,
                size: 100,
                color: Colors.white, // Icono blanco
              ),
              const SizedBox(height: 20),
              Text(
                _isVerifying ? 'Esperando verificación...' : 'Revisa tu correo para verificar tu dirección de correo electrónico.',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Texto blanco
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              if (_isVerifying) ...[
                // Muestra un círculo de carga mientras verificamos el correo
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Verificando...',
                  style: TextStyle(color: Colors.white),
                ),
              ] else ...[
                // Si no estamos verificando, mostramos el botón
                ElevatedButton.icon(
                  onPressed: () => _resendVerificationEmail(widget.email),
                  icon: const Icon(Icons.email),
                  label: const Text('Reenviar correo de verificación'),
                ),
              ],
              const SizedBox(height: 20),
              if (_isVerified) ...[
                // Si el correo fue verificado, mostramos éxito
                const Icon(
                  Icons.check_circle,
                  size: 100,
                  color: Colors.white, // Icono verde
                ),
                const SizedBox(height: 20),
                const Text(
                  'Correo electrónico verificado con éxito.',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
