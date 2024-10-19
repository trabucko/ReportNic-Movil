import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  bool _isRecording = false;
  String? paramedicoNombre; // Aquí almacenaremos el nombre del paramédico
  String? paramedicoApellido;
  String? unidadAmbulancia;
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
        _isRecording = true; // Activar grabación
      });
    }
  }

  void _stopListening() {
    if (_voiceToText.isListening) {
      _voiceToText.stop();
      setState(() {
        _isListening = false;
        _isRecording = false; // Desactivar grabación
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

  // MODIFICAR EL METODO LOGOUT TAMBIEN DE QUE SI NO SE ENCONTRO LO DE TURNOS , SI QUEDO ESPERANDO QUE SIGA CON LO SUYO , O VOLVES A QUITAS TOD0 LO QUE TENGA QUE VER COON TURNOS
  Future<void> _logout() async {
    final firestore = FirebaseFirestore.instance;
    final turnosCollection = firestore.collection('Turnos');

    // Obtener el documento del turno actual del usuario
    final querySnapshot = await turnosCollection.where('enTurno', isEqualTo: true).get();
    final turnDocument = querySnapshot.docs.first;

    // Actualizar el documento del turno para establecer enTurno a false y agregar el campo Final de Turno
    await turnDocument.reference.update({
      'enTurno': false,
      'Final de Turno': FieldValue.serverTimestamp(),
    });

    // Eliminar datos de Secure Storage

    // Cerrar sesión en Firebase
    await FirebaseAuth.instance.signOut();

    // Navegar a la pantalla de inicio de sesión
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isRecording ? Colors.blue : Colors.white, // Cambiar color de fondo de la aplicación
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Paramedico',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${paramedicoNombre ?? 'Paramédico'} ${paramedicoApellido ?? 'Apellido'}',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Terminar Turno Y Cerrar Sesión'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 80,
                color: Colors.transparent,
                child: AppBar(
                  leading: Builder(
                    builder: (context) {
                      return IconButton(
                        icon: const Icon(Icons.sort_rounded),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      );
                    },
                  ),
                  title: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.63,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ReportNic',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    margin: _isEditing ? const EdgeInsets.symmetric(horizontal: 24, vertical: 60) : const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: _isRecording ? Colors.blue : Colors.white, // Cambiar color de fondo
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IntrinsicHeight(
                      child: _isEditing
                          ? Transform.translate(
                              offset: const Offset(0, -60),
                              child: TextField(
                                controller: textEditingController,
                                autofocus: true,
                                onChanged: (value) {
                                  setState(() {
                                    _transcribedText = value;
                                  });
                                },
                                maxLines: null,
                                minLines: 1,
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
                                style: TextStyle(color: _isRecording ? Colors.white : Colors.black), // Cambiar color del texto
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 120.0),
                              child: Text(
                                _isRecording
                                    ? "Grabando..." // Mostrar "Grabando..." cuando _isRecording sea true
                                    : _transcribedText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: _isRecording ? Colors.white : Colors.black, // Cambiar color del texto
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTapDown: (_) => _startListening(),
                onTapUp: (_) => _stopListening(),
                onTapCancel: _stopListening,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _isListening ? 500 : 400,
                  height: _isListening ? 130 : 120,
                  decoration: BoxDecoration(
                    color: _isListening ? const Color.fromARGB(255, 12, 65, 108) : Colors.black, // Cambiar color de fondo
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
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: _isListening ? 130 : 120,
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
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: _isListening ? 130 : 120,
            right: 16,
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                if (_transcribedText.isNotEmpty) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => FichaPacienteScreen(transcribedText: _transcribedText),
                      transitionDuration: const Duration(milliseconds: 500),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                } else {
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
