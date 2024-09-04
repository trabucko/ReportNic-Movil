import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importa este paquete para modificar la barra de estado
import 'Screens/splash_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Asegura la inicialización de los widgets de Flutter
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Inicializa Firebase con las opciones correctas

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Hacer la barra de estado transparente
    statusBarIconBrightness: Brightness
        .dark, // Cambia el brillo del texto de la barra de estado según el fondo
    systemNavigationBarColor: Colors
        .transparent, // Hacer la barra de navegación inferior transparente (opcional)
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReportNic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat', // Configura la fuente globalmente
        scaffoldBackgroundColor: Colors
            .transparent, // Fondo del Scaffold transparente para que el fondo cubra toda la pantalla
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Hacer el AppBar transparente
          elevation: 0, // Quitar la sombra del AppBar
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
