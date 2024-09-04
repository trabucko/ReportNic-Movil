// clinica_dialog.dart
import 'package:flutter/material.dart';

class ClinicaDialog extends StatelessWidget {
  final VoidCallback onBack;

  const ClinicaDialog({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        '¿Estás seguro?',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'El usuario Clínica se encarga de avisar sobre el traslado de pacientes.',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onBack(); // Llama al callback cuando se hace clic en 'Atrás'
            Navigator.of(context).pop(); // Cierra el diálogo
          },
          child: const Text(
            'Atrás',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra el diálogo
          },
          child: const Text(
            'Aceptar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
