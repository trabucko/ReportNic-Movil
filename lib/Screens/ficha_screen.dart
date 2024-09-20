import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FichaPacienteScreen extends StatefulWidget {
  final String transcribedText;
  const FichaPacienteScreen({super.key, required this.transcribedText});

  @override
  FichaPacienteScreenState createState() => FichaPacienteScreenState();
}

class FichaPacienteScreenState extends State<FichaPacienteScreen> {
  TextEditingController systolicController = TextEditingController(text: '120');
  TextEditingController diastolicController = TextEditingController(text: '80');

  void incrementValue(TextEditingController controller) {
    int currentValue = int.tryParse(controller.text) ?? 0;
    setState(() {
      currentValue++;
      controller.text = currentValue.toString();
    });
  }

  void decrementValue(TextEditingController controller) {
    int currentValue = int.tryParse(controller.text) ?? 0;
    if (currentValue > 0) {
      setState(() {
        currentValue--;
        controller.text = currentValue.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    String formattedTime = DateFormat('HH:mm a').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ficha de Paciente'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: $formattedDate', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Hora de Emergencia: $formattedTime', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nombre',
                hintText: 'Nombre del paciente',
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Apellidos',
                hintText: 'Apellidos del Paciente',
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Edad',
                hintText: 'Edad del paciente',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),
            // Texto "Presión" encima de los TextFields de presión sistólica/diastólica
            const Center(
              child: Text(
                'Presión',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Campo de texto para Sistólica con diseño rojo y texto e íconos blancos
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
                              style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
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
                // El "/" entre Sistólica y Diastólica
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '/',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                // Campo de texto para Diastólica con diseño azul y texto e íconos blancos
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
                              style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
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
            const SizedBox(height: 40),
            const Text('Afectaciones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(
              widget.transcribedText,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
