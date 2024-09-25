import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './mapa_screen.dart'; // Asegúrate de importar MapScreen para la navegación

class FichaPacienteScreen extends StatefulWidget {
  final String transcribedText;
  const FichaPacienteScreen({super.key, required this.transcribedText});

  @override
  FichaPacienteScreenState createState() => FichaPacienteScreenState();
}

class FichaPacienteScreenState extends State<FichaPacienteScreen> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController edadController = TextEditingController();
  TextEditingController systolicController = TextEditingController(text: '120');
  TextEditingController diastolicController = TextEditingController(text: '80');

  // Variables para manejar los mensajes de error
  String? nombreError;
  String? apellidosError;
  String? edadError;

  // Función para incrementar el valor de la presión arterial
  void incrementValue(TextEditingController controller) {
    int currentValue = int.tryParse(controller.text) ?? 0;
    setState(() {
      currentValue++;
      controller.text = currentValue.toString();
    });
  }

  // Función para decrementar el valor de la presión arterial
  void decrementValue(TextEditingController controller) {
    int currentValue = int.tryParse(controller.text) ?? 0;
    if (currentValue > 0) {
      setState(() {
        currentValue--;
        controller.text = currentValue.toString();
      });
    }
  }

  // Función para guardar la información e ir a la siguiente pantalla
  void saveAndNavigate() {
    setState(() {
      // Resetear los mensajes de error
      nombreError = null;
      apellidosError = null;
      edadError = null;

      // Validar los campos
      if (nombreController.text.isEmpty) {
        nombreError = "El nombre no puede estar vacío.";
      }
      if (apellidosController.text.isEmpty) {
        apellidosError = "Los apellidos no pueden estar vacíos.";
      }
      if (edadController.text.isEmpty) {
        edadError = "La edad no puede estar vacía.";
      }

      // Si no hay errores, continuar con la navegación
      if (nombreError == null && apellidosError == null && edadError == null) {
        // Crear un mapa con la información del paciente
        Map<String, dynamic> fichaPaciente = {
          'nombre': nombreController.text,
          'apellidos': apellidosController.text,
          'edad': edadController.text,
          'presionSistolica': systolicController.text,
          'presionDiastolica': diastolicController.text,
          'afectaciones': widget.transcribedText,
        };

        // Navegar a MapScreen y pasar la ficha del paciente
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapScreen(fichaPaciente: fichaPaciente), // Pasa el mapa
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    String formattedTime = DateFormat('HH:mm a').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ficha de Paciente'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Tarjeta combinada con fecha, hora de emergencia y datos del paciente
                Card(
                  color: Colors.white,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Fecha y hora
                        Text('Fecha: $formattedDate', style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        Text('Hora de Emergencia: $formattedTime', style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 16),
                        // Formulario de datos personales
                        TextField(
                          controller: nombreController,
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            hintText: 'Nombre del paciente',
                            border: const OutlineInputBorder(),
                            errorText: nombreError, // Mostrar error
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: apellidosController,
                          decoration: InputDecoration(
                            labelText: 'Apellidos',
                            hintText: 'Apellidos del paciente',
                            border: const OutlineInputBorder(),
                            errorText: apellidosError, // Mostrar error
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: edadController,
                          decoration: InputDecoration(
                            labelText: 'Edad',
                            hintText: 'Edad del paciente',
                            border: const OutlineInputBorder(),
                            errorText: edadError, // Mostrar error
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Sección de presión arterial
                Card(
                  color: Colors.white,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Center(
                          child: Text(
                            'Presión Arterial',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Sistólica
                            Column(
                              children: [
                                const Text(
                                  'Sistólica',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                        onPressed: () => decrementValue(systolicController),
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: TextField(
                                          controller: systolicController,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.arrow_drop_up, color: Colors.white),
                                        onPressed: () => incrementValue(systolicController),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '/',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            // Diastólica
                            Column(
                              children: [
                                const Text(
                                  'Diastólica',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                        onPressed: () => decrementValue(diastolicController),
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: TextField(
                                          controller: diastolicController,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.arrow_drop_up, color: Colors.white),
                                        onPressed: () => incrementValue(diastolicController),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Sección de afectaciones
                Card(
                  color: Colors.white,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Afectaciones',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.transcribedText.isEmpty ? 'Sin afectaciones' : widget.transcribedText,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: saveAndNavigate,
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/* 
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
*/