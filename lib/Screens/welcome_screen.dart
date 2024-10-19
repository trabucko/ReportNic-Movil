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

  final ValueNotifier<Color> _skipButtonColorNotifier = ValueNotifier<Color>(Colors.white);

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      int pageIndex = _pageController.page?.round() ?? 0;

      setState(() {
        if (pageIndex == 1) {
          _indicatorColorNotifier.value = Colors.black;
          _skipButtonColorNotifier.value = Colors.black;
        } else {
          _indicatorColorNotifier.value = Colors.white;
          _skipButtonColorNotifier.value = Colors.white;
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
                showSkipButton: true,
              ),
              _buildPage(
                color: Colors.white,
                title: 'Preparación para Emergencias',
                description: 'Con ReportNic, puedes notificar al hospital sobre las condiciones del paciente y la naturaleza de la emergencia, permitiendo al personal médico prepararse adecuadamente antes de la llegada.',
                image: 'assets/img/logo_blackout.png',
                titleColor: Colors.black,
                descriptionColor: Colors.black,
                showStartButton: false,
                showSkipButton: true,
              ),
              _buildPage(
                color: Colors.grey[900]!,
                title: 'Ubicacion Actual',
                description: 'La aplicación al notificar al hospital , comparte la ubicacion actual del paramedico, esto permite visualizar de manera precisa que tan lejos o cerca esta la ambulancia del hospital.',
                image: 'assets/img/logo_amarillo.png',
                titleColor: Colors.white,
                descriptionColor: Colors.white,
                showStartButton: true,
                showSkipButton: false,
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
    required bool showSkipButton,
  }) {
    return Container(
      color: color,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: showSkipButton
                ? ValueListenableBuilder<Color>(
                    valueListenable: _skipButtonColorNotifier,
                    builder: (context, skipButtonColor, child) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text(
                            'Omitir',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: skipButtonColor,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ),
          Center(
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
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        elevation: 5,
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
          ),
        ],
      ),
    );
  }
}
