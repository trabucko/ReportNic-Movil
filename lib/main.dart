import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importa el paquete
import 'Screens/splash_screen.dart';
import 'Screens/login_screen.dart';
import 'Screens/registro_screen.dart';
import './Screens/codigo_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'Screens/home_screen.dart';
import 'Screens/welcome_screen.dart'; // Importa la pantalla de bienvenida
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool _showSplash = true;
  bool _showWelcomeScreen = false;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstLaunch = prefs.getBool('isFirstLaunch');
    if (isFirstLaunch == null || isFirstLaunch) {
      setState(() {
        _showWelcomeScreen = true;
      });
      // Setear el valor a false para que no se muestre de nuevo
      await prefs.setBool('isFirstLaunch', false);
    }
  }

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
      home: _showSplash
          ? const SplashScreen()
          : _showWelcomeScreen
              ? const WelcomeScreen() // Muestra la pantalla de bienvenida
              : StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      User? user = snapshot.data;
                      if (user != null && user.emailVerified) {
                        return const SpeechScreen();
                      } else {
                        return const LoginScreen();
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/codigoScreen': (context) => const CodigoScreen(),
        '/registroScreen': (context) => const RegisterScreen(),
        '/home': (context) => const SpeechScreen(),
      },
    );
  }
}
