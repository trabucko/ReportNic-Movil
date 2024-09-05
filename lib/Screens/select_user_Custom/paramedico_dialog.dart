import 'package:flutter/material.dart';

Future<bool?> showParamedicoDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        '¿Estás seguro?',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'El usuario Paramedico se encarga del envío de datos de pacientes durante emergencias.',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Indica rechazo
          },
          child: const Text(
            'Atrás',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Indica aceptación
          },
          child: const Text(
            'Aceptar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
