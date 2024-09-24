import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importa SharedPreferences

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedUnidad;
  String? _errorMessage;
  bool _obscurePassword = true; // Variable para controlar la visibilidad de la contraseña

  final List<String> _unidadesAmbulancia = [
    'Unidad 101',
    'Unidad 102',
    'Unidad 103',
    'Unidad 104'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/logo_azul.png',
                    width: 130,
                    height: 80,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF007ACC),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_errorMessage != null)
                    Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email, color: Color(0xFF007ACC)), // Ícono de correo
                      labelText: 'Correo Electrónico',
                      labelStyle: TextStyle(
                        fontFamily: 'Jost',
                        color: Color(0xFF007ACC),
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF007ACC)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu correo electrónico';
                      }
                      if (!EmailValidator.validate(value)) {
                        return 'Por favor ingresa un correo electrónico válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock, color: Color(0xFF007ACC)), // Ícono de candado
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: const Color(0xFF007ACC),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      labelText: 'Contraseña',
                      labelStyle: const TextStyle(
                        fontFamily: 'Jost',
                        color: Color(0xFF007ACC),
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF007ACC)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una contraseña';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.local_hospital, color: Color(0xFF007ACC)), // Ícono de ambulancia
                      labelText: 'Unidad de Ambulancia',
                      labelStyle: TextStyle(
                        fontFamily: 'Jost',
                        color: Color(0xFF007ACC),
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF007ACC)),
                      ),
                    ),
                    value: _selectedUnidad,
                    items: _unidadesAmbulancia.map((unidad) {
                      return DropdownMenuItem<String>(
                        value: unidad,
                        child: Text(unidad),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedUnidad = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor selecciona una unidad';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007ACC),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() == true) {
                        await _login();
                      }
                    },
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontFamily: 'Jost',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/tokenscreen');
                    },
                    child: const Text(
                      '¿Todavía no tienes una cuenta? Regístrate aquí',
                      style: TextStyle(
                        color: Color(0xFF007ACC),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Guardar el estado de inicio de sesión en SharedPreferences
  Future<void> _saveLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final firestore = FirebaseFirestore.instance;

    try {
      final querySnapshot = await firestore.collection('usuarios_moviles').where('email', isEqualTo: email).where('contraseña', isEqualTo: password).get();

      if (mounted) {
        if (querySnapshot.docs.isNotEmpty) {
          // Guardar el estado de inicio de sesión
          await _saveLoginState();

          // Autenticación exitosa: Navegar a la pantalla principal
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        } else {
          setState(() {
            _errorMessage = 'Correo electrónico o contraseña incorrectos';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al iniciar sesión';
        });
      }
    }
  }
}
