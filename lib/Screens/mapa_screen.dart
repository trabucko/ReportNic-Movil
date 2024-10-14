import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:reportnic/Screens/info_envio.dart';

class MapScreen extends StatefulWidget {
  final Map<String, dynamic> fichaPaciente;

  const MapScreen({super.key, required this.fichaPaciente});

  @override
  MapaScreenState createState() => MapaScreenState();
}

class MapaScreenState extends State<MapScreen> {
  MapboxMap? _mapboxMap;
  geo.Position? _currentPosition;
  List<dynamic> nearbyHospitals = [];
  bool _isExpanded = true;
  late final Map<String, dynamic> fichaPaciente;
  Map<String, dynamic>? _selectedHospital;

  void _showConfirmationDialog(int index, String hospitalName, Function onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Selección'),
          content: Text('¿Estás seguro de que deseas seleccionar el hospital: $hospitalName?'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 98, 108, 250)), // Cambia el color del botón a azul

              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 98, 108, 250)), // Cambia el color del botón a azul

              onPressed: () async {
                final latHospital = nearbyHospitals[index]['geometry']['coordinates'][1];
                final lonHospital = nearbyHospitals[index]['geometry']['coordinates'][0];
                final eta = await _calculateETA(latHospital, lonHospital);

                setState(() {
                  _selectedHospital = {
                    'name': hospitalName,
                    'coordinates': {
                      'latitude': latHospital,
                      'longitude': lonHospital,
                    },
                    'details': nearbyHospitals[index],
                    'eta': eta, // Guarda el ETA en la variable _selectedHospital
                  };
                });
                onConfirm();
                // Cierra el diálogo
              },
              child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    fichaPaciente = widget.fichaPaciente;
    _selectedHospital = {};
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    if (_currentPosition != null) {
      _moveCameraToCurrentPosition();
      _addMarker();
      _getNearbyHospitals();
    }
  }

  Future<void> _getCurrentLocation() async {
    geo.LocationPermission permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
    }

    if (permission == geo.LocationPermission.whileInUse || permission == geo.LocationPermission.always) {
      _currentPosition = await geo.Geolocator.getCurrentPosition(
        locationSettings: const geo.LocationSettings(
          accuracy: geo.LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      if (_mapboxMap != null) {
        _moveCameraToCurrentPosition();
        _addMarker();
        _getNearbyHospitals();
      }
    }
  }

  void _moveCameraToCurrentPosition() {
    if (_mapboxMap != null && _currentPosition != null) {
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
      final pointAnnotationManager = await _mapboxMap!.annotations.createPointAnnotationManager();
      final ByteData bytes = await rootBundle.load('assets/img/ambulance_marker64px.png');
      final Uint8List list = bytes.buffer.asUint8List();

      var options = PointAnnotationOptions(
        geometry: point,
        image: list,
        iconSize: 0.1,
      );
      await pointAnnotationManager.create(options);
    }
  }

  Future<void> _getNearbyHospitals() async {
    const mapboxToken = 'sk.eyJ1IjoiYXhlbDc3NyIsImEiOiJjbTFhOXp1cHAxb3NkMmxwdWdlejcwN2V1In0.9QQDjdvbGK1qt6d5CGNhBw';
    const query = 'hospital';
    const limit = 8;

    final longitude = _currentPosition?.longitude;
    final latitude = _currentPosition?.latitude;

    if (longitude == null || latitude == null) return;

    final url = 'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?proximity=$longitude,$latitude&access_token=$mapboxToken&limit=$limit';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Map<String, dynamic>> hospitalsWithDistances = [];
      final Set<String> hospitalNamesSet = {}; // Para verificar nombres únicos

      for (var feature in data['features']) {
        final coordinates = feature['geometry']['coordinates'];
        final hospitalName = feature['text'];

        // Si el nombre ya existe en el set, lo ignoramos
        if (hospitalNamesSet.contains(hospitalName)) {
          continue;
        }

        // Agregar el nombre al set para que no se repita
        hospitalNamesSet.add(hospitalName);

        final latHospital = coordinates[1];
        final lonHospital = coordinates[0];

        final distanceInMeters = geo.Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          latHospital,
          lonHospital,
        );

        hospitalsWithDistances.add({
          'hospital': feature,
          'distance': distanceInMeters,
        });

        _addHospitalMarker(latHospital, lonHospital, hospitalName);
      }

      hospitalsWithDistances.sort((a, b) => a['distance'].compareTo(b['distance']));

      setState(() {
        nearbyHospitals = hospitalsWithDistances.map((e) => e['hospital']).toList();
      });
    }
  }

  void _addHospitalMarker(double latitude, double longitude, String hospitalName) async {
    if (_mapboxMap != null) {
      final point = Point(coordinates: Position(longitude, latitude));
      final pointAnnotationManager = await _mapboxMap!.annotations.createPointAnnotationManager();
      final ByteData bytes = await rootBundle.load('assets/img/hospital_marker.png');
      final Uint8List list = bytes.buffer.asUint8List();

      var options = PointAnnotationOptions(
        geometry: point,
        image: list,
        iconSize: 0.08,
        textField: hospitalName,
        textSize: 12.0,
        textOffset: [
          0.0,
          3.0
        ],
        // ignore: deprecated_member_use
        textColor: const Color.fromARGB(255, 65, 73, 186).value,
      );

      await pointAnnotationManager.create(options);
    }
  }

  Future<String> _calculateDistance(double latHospital, double lonHospital) async {
    if (_currentPosition == null) return 'N/D';

    double distanceInMeters = geo.Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      latHospital,
      lonHospital,
    );

    return distanceInMeters < 1000 ? '${distanceInMeters.toStringAsFixed(0)} m' : '${(distanceInMeters / 1000).toStringAsFixed(2)} km';
  }

  Future<String> _calculateETA(double latHospital, double lonHospital) async {
    if (_currentPosition == null) return 'N/D';

    double distanceInMeters = geo.Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      latHospital,
      lonHospital,
    );

    double averageSpeed = 60.0; // en km/h
    double timeInHours = distanceInMeters / (averageSpeed * 1000);
    int minutes = (timeInHours * 60).toInt();
    int seconds = ((timeInHours * 3600) % 60).toInt();

    final now = DateTime.now();
    int delayMinutes = _getTrafficDelay(now.hour);

    minutes += delayMinutes;

    return '$minutes min $seconds s';
  }

  int _getTrafficDelay(int currentHour) {
    if (currentHour >= 6 && currentHour < 14) return 3;
    if (currentHour >= 15 && currentHour < 16) return 5;
    if (currentHour >= 17 && currentHour < 21) return 8;
    return 5; // Horas fuera de pico
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Selecciona el Hospital Destino'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MapWidget(
            onMapCreated: _onMapCreated,
            styleUri: "mapbox://styles/mapbox/streets-v11",
          ),
          Positioned(
            bottom: 0,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 3,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Hospitales Cercanos:                             ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(
                        _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      ),
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_isExpanded)
                  SizedBox(
                    height: 200, // Ajusta la altura según sea necesario
                    child: nearbyHospitals.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: nearbyHospitals.length,
                            itemBuilder: (context, index) {
                              final hospital = nearbyHospitals[index];
                              final hospitalName = hospital['text'];
                              final coordinates = hospital['geometry']['coordinates'];
                              final latHospital = coordinates[1];
                              final lonHospital = coordinates[0];

                              return FutureBuilder<String>(
                                future: Future.wait([
                                  _calculateDistance(latHospital, lonHospital),
                                  _calculateETA(latHospital, lonHospital),
                                ]).then((List<String> results) => '${results[0]} - Llegando en: ${results[1]}'),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  final info = snapshot.data ?? 'N/D';

                                  return Card(
                                    child: ListTile(
                                      tileColor: Colors.blue[50],
                                      hoverColor: Colors.black,
                                      title: Text(hospitalName),
                                      subtitle: Text(
                                        'Distancia: $info',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      trailing: nearbyHospitals[index]['selected'] == true ? const Icon(Icons.check, color: Colors.green) : null,
                                      onTap: () {
                                        final hospitalName = nearbyHospitals[index]['text'];
                                        _showConfirmationDialog(index, hospitalName, () async {
                                          final latHospital = nearbyHospitals[index]['geometry']['coordinates'][1];
                                          final lonHospital = nearbyHospitals[index]['geometry']['coordinates'][0];
                                          final eta = await _calculateETA(latHospital, lonHospital);

                                          setState(() {
                                            _selectedHospital = {
                                              'name': hospitalName,
                                              'coordinates': {
                                                'Ambulancia Coordenadas': {
                                                  'latitude': _currentPosition!.latitude,
                                                  'longitude': _currentPosition!.longitude,
                                                },
                                                'Hospital Coordenadas': {
                                                  'latitude': latHospital,
                                                  'longitude': lonHospital,
                                                },
                                              },
                                              'details': nearbyHospitals[index],
                                              'eta': eta, // Guarda el ETA en la variable _selectedHospital
                                            };
                                          });
                                          // Accede al ETA del hospital seleccionado
                                          // Puedes utilizar el ETA aquí
                                          Navigator.push(
                                            // ignore: use_build_context_synchronously
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => InfoEnvio(
                                                fichaPaciente: fichaPaciente,
                                                hospitalSeleccionado: _selectedHospital!,
                                                eta: eta, // Pasa el ETA como parámetro
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : const Text('Buscando hospitales...'),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
