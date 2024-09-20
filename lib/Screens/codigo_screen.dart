import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CodigoScreen extends StatefulWidget {
  const CodigoScreen({super.key});

  @override
  State<CodigoScreen> createState() => _CodigoScreenState();
}

class _CodigoScreenState extends State<CodigoScreen> {
  final TextEditingController _codigoController = TextEditingController();
  bool _isLoading = false; // Estado de carga
  bool _isValid = true; // Estado de validez del código
  bool _hasTried = false; // Indica si se ha intentado verificar el código

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  Future<void> _verificarCodigo(String codigo) async {
    setState(() {
      _isLoading = true; // Mostrar ícono de carga
      _hasTried = true; // Indicar que se ha intentado verificar
      _isValid = true; // Reiniciar estado de validez
    });

    try {
      final codigoRef = FirebaseFirestore.instance.collection('codigos');
      QuerySnapshot result = await codigoRef.where('codigo', isEqualTo: codigo).limit(1).get();

      if (!mounted) return;

      if (result.docs.isNotEmpty) {
        DocumentSnapshot doc = result.docs.first;
        bool isValido = doc['valido'] ?? false;

        if (isValido) {
          await doc.reference.update({
            'valido': false
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Código válido, registrándose...')),
            );
            Navigator.pushNamed(context, '/registroScreen'); // Asegúrate de que la ruta esté definida
          }
        } else {
          setState(() {
            _isValid = false; // Código ya usado
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Este código ya fue usado.')),
            );
          }
        }
      } else {
        setState(() {
          _isValid = false; // Código inválido
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Código inválido, por favor intente de nuevo')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isValid = false; // Error al verificar
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error verificando el código: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Ocultar ícono de carga
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Ingrese el código proporcionado',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextField(
                      controller: _codigoController,
                      decoration: InputDecoration(
                        labelText: 'Código',
                        labelStyle: const TextStyle(color: Colors.blue),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: _hasTried ? (_isValid ? Colors.green : Colors.red) : Colors.blue,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: _hasTried ? (_isValid ? Colors.green : Colors.red) : Colors.blue,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.security,
                          color: Colors.blue,
                        ),
                      ),
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        // Reiniciar el estado si el usuario está escribiendo
                        setState(() {
                          _isValid = true;
                          _hasTried = false;
                        });
                      },
                    ),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    if (!_isLoading && !_isValid && _hasTried)
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                    if (!_isLoading && _isValid && _hasTried)
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    String codigo = _codigoController.text.trim();
                    if (codigo.isNotEmpty) {
                      _verificarCodigo(codigo);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor ingrese un código válido')),
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
                    'Verificar Código',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  'Si desea registrarse como paramédico, deberá ingresar el código dado por un administrador de su unidad de salud.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/img/logo_blackout.png',
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
                        'Para registrarse como paramédico, necesita un código proporcionado por un administrador. '
                        'Este código es único y se utiliza para que usted pueda registrarse en nuestra plataforma. Si usted '
                        'no ha recibido un código antes de registrarse en ReportNic, por favor comuníquese con el administrador '
                        'de su unidad de salud. Si tiene problemas con el registro, por favor comuníquese con el soporte técnico.'
                        '\n\nAtentamente, Soporte de ReportNic.',
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
