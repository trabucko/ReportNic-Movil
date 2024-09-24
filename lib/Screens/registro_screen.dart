import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controladores para los nuevos campos
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _nombreError;
  String? _apellidoError;
  String? _cedulaError;
  String? _telefonoError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

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
                    'assets/img/logo_azul.png', // Asegúrate de que la ruta de la imagen sea correcta
                    width: 60,
                    height: 40,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Registro de ReportNic',
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF007ACC),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Campo para Nombre
                  TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: const TextStyle(
                        fontFamily: 'Jost',
                        color: Color(0xFF007ACC),
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF007ACC)),
                      ),
                      errorText: _nombreError,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Campo para Apellido
                  TextFormField(
                    controller: _apellidoController,
                    decoration: InputDecoration(
                      labelText: 'Apellido',
                      labelStyle: const TextStyle(
                        fontFamily: 'Jost',
                        color: Color(0xFF007ACC),
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF007ACC)),
                      ),
                      errorText: _apellidoError,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu apellido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Campo para Cédula de Identidad
// Campo para Cédula de Identidad
                  TextFormField(
                    controller: _cedulaController,
                    decoration: InputDecoration(
                      labelText: 'Cédula de Identidad',
                      labelStyle: const TextStyle(
                        fontFamily: 'Jost',
                        color: Color(0xFF007ACC),
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF007ACC)),
                      ),
                      errorText: _cedulaError,
                    ),
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      // Permitir letras y números
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Za-z]')),
                      CedulaInputFormatter(),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu cédula de identidad';
                      }
                      if (!_isCedulaValid(value)) {
                        return 'Cédula de identidad inválida';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Campo para Teléfono
                  TextFormField(
                    controller: _telefonoController,
                    decoration: InputDecoration(
                      labelText: 'Teléfono',
                      labelStyle: const TextStyle(
                        fontFamily: 'Jost',
                        color: Color(0xFF007ACC),
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF007ACC)),
                      ),
                      errorText: _telefonoError,
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu número de teléfono';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Campo para Correo Electrónico
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                      labelStyle: const TextStyle(
                        fontFamily: 'Jost',
                        color: Color(0xFF007ACC),
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF007ACC)),
                      ),
                      errorText: _emailError,
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

                  // Campo para Contraseña
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: const TextStyle(
                        fontFamily: 'Jost',
                        color: Color(0xFF007ACC),
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF007ACC)),
                      ),
                      errorText: _passwordError,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una contraseña';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Campo para Confirmar Contraseña
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Contraseña',
                      labelStyle: const TextStyle(
                        fontFamily: 'Jost',
                        color: Color(0xFF007ACC),
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF007ACC)),
                      ),
                      errorText: _confirmPasswordError,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor confirma tu contraseña';
                      }
                      if (value != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Botón de registro
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007ACC),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() == true) {
                        final cedula = _cedulaController.text.trim();
                        final cedulaValida = _isCedulaValid(cedula);

                        if (cedulaValida) {
                          _register();
                        } else {
                          setState(() {
                            _cedulaError = 'Cédula de identidad inválida';
                          });
                        }
                      }
                    },
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(
                        fontFamily: 'Jost',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _register() async {
    final nombre = _nombreController.text.trim();
    final apellido = _apellidoController.text.trim();
    final cedula = _cedulaController.text.trim();
    final telefono = _telefonoController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final fechaYHoraActual = DateTime.now();

    try {
      // Crear usuario en Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guardar información adicional en Firestore
      await FirebaseFirestore.instance.collection('usuarios_moviles').doc(userCredential.user!.uid).set({
        'nombre': nombre,
        'apellido': apellido,
        'cedula': cedula,
        'telefono': telefono,
        'email': email,
        'contraseña': password,
        'Fecha de Creacion': fechaYHoraActual,
      });

      // Usar Navigator.pushReplacement dentro del contexto válido
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          // Verificar que el contexto aún esté montado
          Navigator.of(context).pushReplacementNamed('/login');
        }
      });
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          // Verificar que el contexto aún esté montado
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error en el registro')),
          );
        }
      });
    }
  }

  Future<bool> verificarCedula(String cedula) async {
    try {
      final response = await http.get(Uri.parse('https://api.example.com/verify_cedula?cedula=$cedula'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['valid'] == true;
      } else {
        throw Exception('Error al verificar la cédula');
      }
    } catch (e) {
      return false;
    }
  }

  bool _isCedulaValid(String cedula) {
    // Validar cédula con formato XXX-XXXXXX-XXXXX y última X siendo una letra
    final RegExp cedulaRegex = RegExp(r'^\d{3}-\d{6}-\d{4}[A-Z]$');
    return cedulaRegex.hasMatch(cedula);
  }
}

// Formato de entrada para cédula
class CedulaInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text.toUpperCase().replaceAll(RegExp(r'[^0-9A-Za-z]'), '');
    final String formattedText = _formatCedula(newText);

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatCedula(String value) {
    final StringBuffer buffer = StringBuffer();
    final int length = value.length;

    if (length <= 3) {
      buffer.write(value);
    } else if (length <= 9) {
      buffer.write('${value.substring(0, 3)}-${value.substring(3)}');
    } else if (length <= 14) {
      buffer.write('${value.substring(0, 3)}-${value.substring(3, 9)}-${value.substring(9)}');
    } else {
      buffer.write('${value.substring(0, 3)}-${value.substring(3, 9)}-${value.substring(9, 14)}');
    }

    return buffer.toString();
  }
}
