import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_to_text/voice_to_text.dart';
import './ficha_screen.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  late VoiceToText _voiceToText;
  bool _isListening = false;
  bool _isEditing = false;
  String _transcribedText = "Mantén presionado el botón para hablar";
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  void _initializeSpeech() {
    _voiceToText = VoiceToText(stopFor: 100);
    _voiceToText.initSpeech();

    _voiceToText.addListener(() {
      if (mounted) {
        setState(() {
          _transcribedText = _voiceToText.speechResult;
        });
      }
    });
  }

  void _startListening() {
    if (_voiceToText.isNotListening) {
      _voiceToText.startListening();
      setState(() {
        _isListening = true;
      });
    }
  }

  void _stopListening() {
    if (_voiceToText.isListening) {
      _voiceToText.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        textEditingController.text = _transcribedText;
      } else {
        _transcribedText = textEditingController.text;
      }
    });
  }

  Future<void> _logout() async {
    // Lógica de cierre de sesión, por ejemplo, limpiar el estado de autenticación
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Establece isLoggedIn como false

    // Navega a la pantalla de login después de un pequeño retraso
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 80,
                color: Colors.transparent,
                child: AppBar(
                  leading: const Icon(
                    Icons.sort_rounded,
                    color: Colors.black,
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  title: const Center(
                    child: Text(
                      "ReportNic",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: _logout, // Llama a la función para cerrar sesión
                      child: const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Icon(
                          Icons.logout,
                          color: Colors.black,
                          size: 30, // Tamaño del ícono
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    padding: const EdgeInsets.all(16.0),
                    child: IntrinsicHeight(
                      child: _isEditing
                          ? TextField(
                              controller: textEditingController,
                              autofocus: true,
                              onChanged: (value) {
                                setState(() {
                                  _transcribedText = value;
                                });
                              },
                              maxLines: null, // Permite múltiples líneas
                              minLines: 1, // Altura mínima para el TextField
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue, width: 1.0),
                                ),
                                hintText: 'Edita tu mensaje...',
                                hintStyle: TextStyle(color: Colors.blue[300]),
                              ),
                              cursorColor: Colors.blue,
                            )
                          : Text(
                              _transcribedText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Botón de micrófono con animación
          Positioned(
            bottom: 0, // Pega el botón al fondo de la pantalla
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTapDown: (_) => _startListening(),
                onTapUp: (_) => _stopListening(),
                onTapCancel: _stopListening,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _isListening ? 500 : 400, // Ajusta el tamaño cuando está escuchando
                  height: _isListening ? 130 : 120,
                  decoration: BoxDecoration(
                    color: _isListening ? Colors.green : Colors.black, // Cambia a verde cuando está escuchando
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                    ),
                  ),
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          // Botón para editar el texto
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: _isListening ? 130 : 120, // Mueve el botón cuando se activa el micrófono
            left: 16,
            child: FloatingActionButton(
              onPressed: _toggleEditMode,
              backgroundColor: Colors.black,
              child: Icon(
                _isEditing ? Icons.check : Icons.edit,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          // Botón de enviar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: _isListening ? 130 : 120, // Mueve el botón cuando se activa el micrófono
            right: 16,
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                if (_transcribedText.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FichaPacienteScreen(transcribedText: _transcribedText),
                    ),
                  );
                } else {
                  // Muestra un mensaje si el texto está vacío
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No hay texto transcrito para enviar')),
                  );
                }
              },
              backgroundColor: Colors.black,
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
