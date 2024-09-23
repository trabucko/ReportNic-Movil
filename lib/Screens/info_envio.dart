import 'package:flutter/material.dart';

class InfoEnvio extends StatelessWidget {
  final Map<String, dynamic> fichaPaciente;
  final Map<String, dynamic> hospitalSeleccionado;

  const InfoEnvio({
    super.key,
    required this.fichaPaciente,
    required this.hospitalSeleccionado,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información de Envío'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Información del Paciente:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Mostrar aquí la información de FichaPaciente
            Text('Nombre: ${fichaPaciente['nombre']}'),
            Text('Apellidos: ${fichaPaciente['apellidos']}'),
            Text('Edad: ${fichaPaciente['edad']}'),
            Text('Presión Sistólica: ${fichaPaciente['presionSistolica']}'),
            Text('Presión Diastólica: ${fichaPaciente['presionDiastolica']}'),
            Text('Afectaciones: ${fichaPaciente['afectaciones']}'),
            const SizedBox(height: 20),
            const Text('Hospital Seleccionado:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Nombre: ${hospitalSeleccionado['name']}'),
            Text('Coordenadas: ${hospitalSeleccionado['coordinates']['latitude']}, ${hospitalSeleccionado['coordinates']['longitude']}'),
            // Agrega más campos según la información que desees mostrar
          ],
        ),
      ),
    );
  }
}
