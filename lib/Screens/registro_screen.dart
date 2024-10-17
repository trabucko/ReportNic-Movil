import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:reportnic/Screens/email_verification_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

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

  final PageController _pageController = PageController();
  int currentPage = 0;

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
                  SizedBox(
                    height: 400,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (page) {
                        setState(() {
                          currentPage = page;
                        });
                      },
                      children: [
                        _buildPage1(),
                        _buildPage2(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Mostrar el botón de "Siguiente" solo en la primera página
                  // Mostrar el botón de "Siguiente" solo en la primera página
                  // Mostrar el botón de "Siguiente" solo en la primera página
                  if (currentPage == 0)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007ACC),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          final cedula = _cedulaController.text.trim();
                          final cedulaValida = _isCedulaValid(cedula);

                          if (cedulaValida) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            setState(() {
                              _cedulaError = 'Cédula de identidad inválida';
                            });
                          }
                        }
                      },
                      child: const Text(
                        'Siguiente',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),

// Mostrar el botón de "Registrar" solo en la segunda página
                  if (currentPage == 1)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007ACC),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          _register();
                        }
                      },
                      child: const Text(
                        'Registrar',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          color: Colors.white,
                          fontSize: 18,
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

  Widget _buildPage1() {
    return ListView(
      shrinkWrap: true,
      children: [
        _buildTextField(
          label: 'Nombre',
          controller: _nombreController,
          errorText: _nombreError,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu nombre';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Apellido',
          controller: _apellidoController,
          errorText: _apellidoError,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu apellido';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Cédula de Identidad',
          controller: _cedulaController,
          errorText: _cedulaError,
          keyboardType: TextInputType.text,
          inputFormatters: [
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
        _buildTextField(
          label: 'Teléfono',
          controller: _telefonoController,
          errorText: _telefonoError,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu número de teléfono';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPage2() {
    return Column(
      children: [
        _buildTextField(
          label: 'Correo Electrónico',
          controller: _emailController,
          errorText: _emailError,
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
        _buildTextField(
          label: 'Contraseña',
          controller: _passwordController,
          errorText: _passwordError,
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa una contraseña';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Confirmar Contraseña',
          controller: _confirmPasswordController,
          errorText: _confirmPasswordError,
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
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(
                  fontFamily: 'Jost',
                  color: Color(0xFF007ACC),
                ),
                border: InputBorder.none,
              ),
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              obscureText: obscureText,
              validator: validator,
            ),
          ),
        ),
        if (errorText != null && errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  // Método para validar la cédula
  bool _isCedulaValid(String cedula) {
    final RegExp cedulaRegex = RegExp(r'^\d{3}-\d{6}-\d{4}[A-Z]$');
    return cedulaRegex.hasMatch(cedula);
  }

  // Método para registrar el usuario
  void _register() async {
    final nombre = _nombreController.text.trim();
    final apellido = _apellidoController.text.trim();
    final cedula = _cedulaController.text.trim();
    final telefono = _telefonoController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final fechaYHoraActual = DateTime.now();
    final idParamedico = await getNextParamedicoID();

    try {
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Enviar verificación de correo
      userCredential.user?.sendEmailVerification();

      // Navegar a la pantalla de verificación
      final verified = await Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => EmailVerificationScreen(
            email: email,
            nombre: nombre,
            apellido: apellido,
            cedula: cedula,
            telefono: telefono,
            password: password,
            fechaYHoraActual: fechaYHoraActual,
            idParamedico: idParamedico,
          ),
        ),
      );

      if (!verified) {
        _showErrorDialog('Por favor verifica tu correo electrónico');
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<String> getNextParamedicoID() async {
    final snapshot = await FirebaseFirestore.instance.collection('usuarios_moviles').orderBy('IdParamedico', descending: true).limit(1).get();

    if (snapshot.docs.isEmpty) {
      return '001'; // If there are no records, start from '001'
    } else {
      final lastDocId = snapshot.docs.first.get('IdParamedico');

      // Try to parse the last ID as an integer
      try {
        final lastIdNumber = int.parse(lastDocId); // Convert the ID to a number
        final newIdNumber = lastIdNumber + 1; // Increment the ID
        return newIdNumber.toString().padLeft(3, '0'); // Format to 3 digits
      } catch (e) {
        return '001'; // Fallback if there is an error
      }
    }
  }

  // Método para mostrar un diálogo de error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
