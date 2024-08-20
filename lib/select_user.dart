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

  void _selectParamedico() {
    setState(() {
      isParamedicoSelected = true;
      isClinicaSelected = false;
    });
  }

  void _selectClinica() {
    setState(() {
      isClinicaSelected = true;
      isParamedicoSelected = false;
    });
  }

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
              fontSize: screenWidth * 0.07,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: kToolbarHeight - 10),
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
                          color:
                              isClinicaSelected ? Colors.green : Colors.white,
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
