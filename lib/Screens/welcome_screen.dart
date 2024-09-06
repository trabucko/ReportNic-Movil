import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  final ValueNotifier<Color> _indicatorColorNotifier = ValueNotifier<Color>(Colors.white);

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int pageIndex = _pageController.page?.round() ?? 0;
      setState(() {
        if (pageIndex == 1) {
          _indicatorColorNotifier.value = Colors.black; // Color para la página blanca
        } else {
          _indicatorColorNotifier.value = Colors.white; // Color para las otras páginas
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              _buildPage(
                color: Colors.blue,
                title: 'Bienvenido a ReportNic',
                description: 'Nuestra aplicación está diseñada para que los paramédicos informen sobre emergencias antes de llegar al hospital. Esto asegura que el hospital esté preparado para tomar las medidas adecuadas.',
                image: 'assets/img/logo_blanco.png',
                titleColor: Colors.white,
                descriptionColor: Colors.white,
                showStartButton: false,
              ),
              _buildPage(
                color: Colors.white,
                title: 'Preparación para Emergencias',
                description: 'Con ReportNic, puedes notificar al hospital sobre las condiciones del paciente y la naturaleza de la emergencia, permitiendo al personal médico prepararse adecuadamente antes de la llegada.',
                image: 'assets/img/logo_blackout.png',
                titleColor: Colors.black,
                descriptionColor: Colors.black,
                showStartButton: false,
              ),
              _buildPage(
                color: Colors.grey[900]!,
                title: 'Traslado de Pacientes',
                description: 'La aplicación también es útil durante el traslado de pacientes, asegurando que los hospitales reciban la información necesaria para una atención eficaz y oportuna.',
                image: 'assets/img/logo_amarillo.png',
                titleColor: Colors.white,
                descriptionColor: Colors.white,
                showStartButton: true,
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ValueListenableBuilder<Color>(
                valueListenable: _indicatorColorNotifier,
                builder: (context, activeColor, child) {
                  return SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: WormEffect(
                      dotColor: Colors.grey,
                      activeDotColor: activeColor,
                      dotHeight: 8.0,
                      dotWidth: 8.0,
                      spacing: 16.0,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required Color color,
    required String title,
    required String description,
    required String image,
    required Color titleColor,
    required Color descriptionColor,
    required bool showStartButton,
  }) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: descriptionColor,
              ),
            ),
          ),
          if (showStartButton)
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: ElevatedButton(
                onPressed: () {
                  // Maneja el evento del botón "Comenzar"
                  Navigator.pushReplacementNamed(context, '/selectu'); // Asegúrate de definir la ruta '/home'
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.amber, // Color del texto del botón
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Radio de borde del botón
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Padding interno
                  elevation: 5, // Sombra del botón
                ),
                child: const Text(
                  'Comenzar',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
