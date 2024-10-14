import 'package:firebase_auth/firebase_auth.dart';
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
  WidgetsFlutterBinding.ensureInitialized();

  String accessToken = 'sk.eyJ1IjoiYXhlbDc3NyIsImEiOiJjbTFhOXp1cHAxb3NkMmxwdWdlejcwN2V1In0.9QQDjdvbGK1qt6d5CGNhBw';
  MapboxOptions.setAccessToken(accessToken);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
  ));

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthState(),
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReportNic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Jost',
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user != null && user.emailVerified) {
              // Email verification is successful, update the UI
              return const SpeechScreen();
            } else {
              // Email verification is not successful, show the verification screen
              return isLoggedIn ? const LoginScreen() : const SplashScreen();
            }
          } else {
            // Show a loading screen while waiting for the authentication state
            return const SplashScreen();
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/tokenscreen': (context) => const CodigoScreen(),
        '/registroScreen': (context) => const RegisterScreen(),
        '/home': (context) => const SpeechScreen(),
      },
    );
  }
}
