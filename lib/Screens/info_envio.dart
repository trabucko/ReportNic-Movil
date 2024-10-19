import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reportnic/Screens/home_screen.dart';

class InfoEnvio extends StatelessWidget {
  final Map<String, dynamic> fichaPaciente;
  final Map<String, dynamic> hospitalSeleccionado;
  final String eta;

  const InfoEnvio({
    super.key,
    required this.fichaPaciente,
    required this.hospitalSeleccionado,
    required this.eta,
  });

  void _enviarDatos(BuildContext context) async {
    final firestore = FirebaseFirestore.instance;
    final fechaYHoraActual = DateTime.now();

    await firestore.collection('Emergencias').add({
      'fichaPaciente': fichaPaciente,
      'hospitalSeleccionado': {
        'nombre': hospitalSeleccionado['name'],
        'coordenadas': {
          'latitude': hospitalSeleccionado['coordinates']['Hospital Coordenadas']['latitude'],
          'longitude': hospitalSeleccionado['coordinates']['Hospital Coordenadas']['longitude'],
        },
      },
      'coordenadasActuales': {
        'latitude': hospitalSeleccionado['coordinates']['Ambulancia Coordenadas']['latitude'],
        'longitude': hospitalSeleccionado['coordinates']['Ambulancia Coordenadas']['longitude'],
      },
      'fechaYHora': fechaYHoraActual,
      'eta': eta,
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Emergencia enviada'),
          backgroundColor: Colors.blue,
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SpeechScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 8,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: const Text(
            'Información de Envío',
            style: TextStyle(color: Colors.black),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 1),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.blue[300],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Ficha Paciente',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 20.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alinear a la izquierda
                  children: [
                    const Text(
                      'Información del Paciente',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E90FF),
                      ),
                    ),
                    const Divider(color: Color(0xFF1E90FF)),
                    _buildFichaRow('Nombre', fichaPaciente['nombre']),
                    _buildFichaRow('Apellidos', fichaPaciente['apellidos']),
                    _buildFichaRow('Edad', '${fichaPaciente['edad']}  años'),
                    _buildFichaRow('Presión Sistólica', '${fichaPaciente['presionSistolica']} mmHg'),
                    _buildFichaRow('Presión Diastólica', '${fichaPaciente['presionDiastolica']} mmHg'),
                    _buildFichaRowLargo('Afectaciones', fichaPaciente['afectaciones']),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alinear a la izquierda
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Hospital Destino',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E90FF),
                        ),
                      ),
                    ),
                    const Divider(color: Color(0xFF1E90FF)),
                    _buildFichaRow('Nombre: ', hospitalSeleccionado['name']),
                    _buildFichaRow(
                      'Coordenadas Actuales: ',
                      '${hospitalSeleccionado['coordinates']['Ambulancia Coordenadas']['latitude']}, ${hospitalSeleccionado['coordinates']['Ambulancia Coordenadas']['longitude']}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                onPressed: () => _enviarDatos(context),
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text(
                  'Enviar Datos',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E90FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFichaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFichaRowLargo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
            overflow: TextOverflow.visible,
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
