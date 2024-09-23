import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importa este paquete para modificar la barra de estado
import 'Screens/splash_screen.dart';
import 'Screens/login_screen.dart'; // Importa la pantalla de login
import 'Screens/registro_screen.dart';
import './Screens/codigo_screen.dart';
import 'firebase_options.dart'; // Importa la librería para trabajar con la base de datos
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart'; // Importa Provider
import 'services/auth_service.dart'; // Asegúrate de importar el archivo donde está AuthState
import 'Screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart'; // Asegúrate de tener este paquete instalado

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura la inicialización de los widgets de Flutter

  String accessToken = 'sk.eyJ1IjoiYXhlbDc3NyIsImEiOiJjbTFhOXp1cHAxb3NkMmxwdWdlejcwN2V1In0.9QQDjdvbGK1qt6d5CGNhBw'; // Reemplaza con tu token real
  MapboxOptions.setAccessToken(accessToken);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Inicializa Firebase con las opciones correctas

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Hacer la barra de estado transparente
    statusBarIconBrightness: Brightness.dark, // Cambia el brillo del texto de la barra de estado según el fondo
    systemNavigationBarColor: Colors.transparent, // Hacer la barra de navegación inferior transparente (opcional)
  ));

  // Verificar el estado de inicio de sesión del usuario
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthState(),
      child: MyApp(isLoggedIn: isLoggedIn), // Pasar el estado de inicio de sesión a la aplicación
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn; // Añadir una propiedad para el estado de inicio de sesión

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReportNic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Jost', // Configura la fuente globalmente
        scaffoldBackgroundColor: Colors.transparent, // Fondo del Scaffold transparente para que el fondo cubra toda la pantalla
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Hacer el AppBar transparente
          elevation: 0, // Quitar la sombra del AppBar
        ),
      ),
      // Si el usuario ya está logueado, ir directamente a la pantalla HomeScreen, de lo contrario mostrar LoginScreen
      home: isLoggedIn ? const SpeechScreen() : const SplashScreen(), // Cambiar dependiendo del estado de inicio de sesión
      routes: {
        '/login': (context) => const LoginScreen(),
        '/tokenscreen': (context) => const CodigoScreen(),
        '/registroScreen': (context) => const RegisterScreen(),
        '/home': (context) => const SpeechScreen(),
      },
    );
  }
}
