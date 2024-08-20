import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class SelectScreen extends StatelessWidget {
  const SelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtén las dimensiones de la pantalla
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'REPORTNIC',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth *
                  0.07, // Ajusta el tamaño del texto según el ancho de la pantalla
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: kToolbarHeight - 10,
              ),
              Center(
                child: Text(
                  '¿Quién usará la aplicación?',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: screenWidth *
                        0.05, // Ajusta el tamaño del texto según el ancho de la pantalla
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                  height: screenHeight *
                      0.05), // Ajusta el espacio según la altura de la pantalla
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: screenWidth *
                          0.4, // Ajusta el tamaño según el ancho de la pantalla
                      width: screenWidth * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Icon(
                        Icons.healing,
                        size: screenWidth *
                            0.2, // Ajusta el tamaño del ícono según el ancho de la pantalla
                      ),
                    ),
                    SizedBox(
                        height: screenHeight *
                            0.02), // Ajusta el espacio según la altura de la pantalla
                    Text(
                      'Paramédico',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        fontSize: screenWidth *
                            0.04, // Ajusta el tamaño del texto según el ancho de la pantalla
                      ),
                    ),
                    SizedBox(
                        height: screenHeight *
                            0.05), // Ajusta el espacio según la altura de la pantalla
                    Container(
                      height: screenWidth *
                          0.4, // Ajusta el tamaño según el ancho de la pantalla
                      width: screenWidth * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Icon(
                        Icons.local_hospital,
                        size: screenWidth *
                            0.2, // Ajusta el tamaño del ícono según el ancho de la pantalla
                      ),
                    ),
                    SizedBox(
                        height: screenHeight *
                            0.02), // Ajusta el espacio según la altura de la pantalla
                    Text(
                      'Clínica',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        fontSize: screenWidth *
                            0.04, // Ajusta el tamaño del texto según el ancho de la pantalla
                      ),
                    ),
                    SizedBox(
                        height: screenHeight *
                            0.1), // Espacio adicional para evitar que la onda cubra el texto
                  ],
                ),
              ),
            ],
          ),
          Align(
            // WAVE
            alignment: Alignment.bottomCenter,
            child: WaveWidget(
              config: CustomConfig(
                colors: [
                  Colors.blueAccent.withOpacity(0.3),
                  Colors.blueAccent.withOpacity(0.5),
                  Colors.blueAccent.withOpacity(0.7),
                  Colors.blueAccent,
                ],
                durations: [35000, 19440, 10800, 6000],
                heightPercentages: [0.20, 0.23, 0.25, 0.30],
                blur: const MaskFilter.blur(BlurStyle.solid, 10),
              ),
              size: Size(
                  double.infinity,
                  screenHeight *
                      0.15), // Ajusta la altura de la ola según la altura de la pantalla
              waveAmplitude: 20,
            ),
          ),
        ],
      ),
    );
  }
}
