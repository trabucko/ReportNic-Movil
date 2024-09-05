import 'package:flutter/material.dart';
import 'select_user.dart'; // Asegúrate de que este archivo esté correctamente importado

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Duración de la animación
      vsync: this,
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadResourcesAndNavigate();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _preloadResourcesAndNavigate() async {
    // Precargar imágenes
    await precacheImage(const AssetImage('assets/img/backgroundGrey.jpeg'), context);

    // Si necesitas precargar fuentes personalizadas, hazlo aquí
    const textStyle = TextStyle(
      fontFamily: 'Jost',
      fontSize: 20,
    );

    final textPainter = TextPainter(
      text: const TextSpan(text: 'Preload', style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Iniciar la animación
    _controller.forward().then((_) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const SelectScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Transición de desvanecimiento
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blue, // Color de fondo del splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.local_hospital,
              size: screenSize.width * 0.25,
              color: Colors.white,
            ),
            SizedBox(height: screenSize.height * 0.02),
            Text(
              'ReportNic',
              style: TextStyle(
                fontFamily: 'Jost', // Asegúrate de usar la fuente correcta
                fontSize: screenSize.width * 0.07,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: screenSize.height * 0.05),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
