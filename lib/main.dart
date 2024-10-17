import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Screens/splash_screen.dart';
import 'Screens/login_screen.dart';
import 'Screens/registro_screen.dart';
import './Screens/codigo_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'Screens/home_screen.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

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

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthState(),
      child: const MyApp(),
    ),
  );
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
              // Si el usuario está autenticado y su correo está verificado
              return const SpeechScreen();
            } else {
              // Si el usuario no está autenticado o no ha verificado su correo
              return const LoginScreen();
            }
          } else {
            // Muestra una pantalla de carga mientras se espera el estado de autenticación
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
