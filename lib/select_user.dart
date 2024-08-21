import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class SelectScreen extends StatefulWidget {
  const SelectScreen({super.key});

  @override
  SelectScreenState createState() => SelectScreenState();
}

class SelectScreenState extends State<SelectScreen> {
  bool isParamedicoSelected = false;
  bool isClinicaSelected = false;
  List<Color> waveColors = [
    const Color.fromARGB(255, 99, 93, 93).withOpacity(0.9),
    const Color.fromARGB(255, 99, 93, 93).withOpacity(0.8),
    const Color.fromARGB(255, 99, 93, 93).withOpacity(0.7),
    const Color.fromARGB(255, 163, 162, 162),
  ];

  void _selectParamedico() {
    setState(() {
      isParamedicoSelected = true;
      isClinicaSelected = false;
      // Actualiza los colores de la onda
      waveColors = [
        Colors.blue.withOpacity(0.7),
        Colors.blue.withOpacity(0.6),
        Colors.blue.withOpacity(0.5),
        Colors.blue,
      ];
    });
  }

  void _selectClinica() {
    setState(() {
      isClinicaSelected = true;
      isParamedicoSelected = false;
      // Actualiza los colores de la onda
      waveColors = [
        Colors.red.withOpacity(0.7),
        Colors.red.withOpacity(0.6),
        Colors.red.withOpacity(0.5),
        Colors.red,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/backgroundGrey.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                color: Colors.white.withOpacity(0.0),
                padding: EdgeInsets.only(
                    top: mediaQuery.padding.top + 55,
                    bottom: mediaQuery.padding.bottom + 18),
                child: Center(
                  child: Text(
                    'REPORTNIC',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.07,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  '¿Quién usará la aplicación?',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _selectParamedico,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: screenWidth * 0.4,
                        width: screenWidth * 0.4,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color:
                              isParamedicoSelected ? Colors.blue : Colors.white,
                        ),
                        child: Icon(
                          Icons.healing,
                          size: screenWidth * 0.2,
                          color: isParamedicoSelected
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Paramédico',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    GestureDetector(
                      onTap: _selectClinica,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: screenWidth * 0.4,
                        width: screenWidth * 0.4,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: isClinicaSelected ? Colors.red : Colors.white,
                        ),
                        child: Icon(
                          Icons.local_hospital,
                          size: screenWidth * 0.2,
                          color:
                              isClinicaSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Clínica',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.1),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: WaveWidget(
              config: CustomConfig(
                colors: waveColors, // Usa la lista de colores dinámica
                durations: [35000, 19440, 10800, 6000],
                heightPercentages: [0.20, 0.23, 0.25, 0.30],
                blur: const MaskFilter.blur(BlurStyle.solid, 10),
              ),
              size: Size(
                double.infinity,
                screenHeight * 0.15,
              ),
              waveAmplitude: 20,
            ),
          ),
        ],
      ),
    );
  }
}
