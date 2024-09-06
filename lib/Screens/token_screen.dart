import 'package:flutter/material.dart';

class TokenScreen extends StatefulWidget {
  const TokenScreen({super.key});

  @override
  State<TokenScreen> createState() => _TokenScreenState();
}

class _TokenScreenState extends State<TokenScreen> {
  final TextEditingController _tokenController = TextEditingController();

  @override
  void dispose() {
    _tokenController.dispose(); // Liberar recursos cuando no sea necesario
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Ingrese el token proporcionado',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _tokenController,
                  decoration: InputDecoration(
                    labelText: 'Token',
                    labelStyle: const TextStyle(color: Colors.blue),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(
                      Icons.security,
                      color: Colors.blue,
                    ),
                  ),
                  cursorColor: Colors.blue,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    String token = _tokenController.text.trim();
                    if (token.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Token ingresado correctamente')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor ingrese un token válido')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Verificar Token',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  'Si desea Registrarse como paramédico, deberá ingresar el token dado por un administrador de su unidad de salud.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/img/logo_blackout.png', // Revisa que esta ruta sea válida
                  width: 30,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported, color: Colors.red);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(
                Icons.info_outline,
                color: Colors.blue,
                size: 30,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: const Text(
                        'Información',
                        style: TextStyle(color: Colors.black),
                      ),
                      content: const Text(
                        'Para registrarse como paramédico, necesita un token proporcionado por un administrador. '
                        'Este token es único y se utiliza para que usted pueda registrarse en nuestra plataforma. Si usted '
                        'no ha recibido un token antes de registrarse en ReportNic , por favor Comunicarse con el administrador'
                        ' de su unidad de salud, Si tiene problemas con el registro, por favor comuníquese con el soporte técnico.'
                        '\n\nAtentamente Soporte de ReportNic.',
                        style: TextStyle(color: Colors.black54),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Cerrar',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
