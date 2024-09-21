import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart'; // Asegúrate de tener este paquete instalado

class MapScreen extends StatelessWidget {
  final CameraOptions camera;

  MapScreen({super.key})
      : camera = CameraOptions(
          center: Point(coordinates: Position(-98.0, 39.5)), // Coordenadas iniciales (ajusta si es necesario)
          zoom: 2, // Nivel de zoom inicial
          bearing: 0, // Inclinación
          pitch: 0, // Ángulo
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapbox Example'), // Título de la barra superior
      ),
      body: MapWidget(
        cameraOptions: camera, // Pasa las opciones de la cámara al mapa
        onMapCreated: (controller) {
          // Este callback se llama cuando el mapa ha sido creado
          print("Mapa creado correctamente");
        },
      ),
    );
  }
}
