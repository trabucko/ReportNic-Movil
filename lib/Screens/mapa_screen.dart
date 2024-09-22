import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geo; // Usa un prefijo
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapaScreenState createState() => MapaScreenState();
}

class MapaScreenState extends State<MapScreen> {
  MapboxMap? _mapboxMap;
  geo.Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Obtén la ubicación al iniciar
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;

    if (_currentPosition != null) {
      _moveCameraToCurrentPosition();
      _addMarker();
    }
  }

  Future<void> _getCurrentLocation() async {
    geo.LocationPermission permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
    }

    if (permission == geo.LocationPermission.whileInUse || permission == geo.LocationPermission.always) {
      // Obtener la ubicación actual
      _currentPosition = await geo.Geolocator.getCurrentPosition(
        locationSettings: const geo.LocationSettings(
          accuracy: geo.LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      // Si el mapa ya está cargado, mueve la cámara y añade el marcador
      if (_mapboxMap != null) {
        _moveCameraToCurrentPosition();
        _addMarker();
      }
    } else {
      // Manejar el caso de permisos denegados
    }
  }

  void _moveCameraToCurrentPosition() {
    if (_mapboxMap != null && _currentPosition != null) {
      // Mover la cámara a la ubicación actual
      _mapboxMap!.flyTo(
        CameraOptions(
          center: Point(coordinates: Position(_currentPosition!.longitude, _currentPosition!.latitude)),
          zoom: 14.0,
        ),
        MapAnimationOptions(duration: 1500),
      );
    }
  }

  void _addMarker() async {
    if (_mapboxMap != null && _currentPosition != null) {
      final point = Point(coordinates: Position(_currentPosition!.longitude, _currentPosition!.latitude));

      // Crear el gestor de anotaciones
      final pointAnnotationManager = await _mapboxMap!.annotations.createPointAnnotationManager();

      final ByteData bytes = await rootBundle.load('assets/img/ambulance_marker64px.png');
      final Uint8List list = bytes.buffer.asUint8List();

      // Crea la opción de anotación
      var options = PointAnnotationOptions(
        geometry: point,
        image: list,
        iconSize: 0.1, // Ajusta este valor según el tamaño original de la imagen
      );

      // Crea la anotación
      await pointAnnotationManager.create(options);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      body: MapWidget(
        onMapCreated: _onMapCreated,
        styleUri: "mapbox://styles/mapbox/streets-v11",
      ),
    );
  }
}
