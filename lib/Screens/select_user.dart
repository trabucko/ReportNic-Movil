import 'package:flutter/material.dart';
import 'select_User_Custom/paramedico_dialog.dart';
import 'select_User_Custom/clinica_dialog.dart';
import 'select_User_Custom/wave_color.dart';
import 'select_User_Custom/custom_widgets.dart';

class SelectScreen extends StatefulWidget {
  const SelectScreen({super.key});

  @override
  SelectScreenState createState() => SelectScreenState();
}

class SelectScreenState extends State<SelectScreen> {
  bool isParamedicoSelected = false;
  bool isClinicaSelected = false;
  List<Color> waveColors = WaveColors.defaultWaveColors;

  void _selectParamedico() async {
    setState(() {
      isParamedicoSelected = true;
      isClinicaSelected = false;
      waveColors = WaveColors.blueWaveColors;
    });

    final bool? accepted = await showParamedicoDialog(context);
    if (mounted) {
      // Verifica que el widget aún esté montado
      if (accepted == true) {
        Navigator.pushReplacementNamed(context, '/tokenscreen'); // Cambia la ruta según tu configuración
      } else {
        setState(() {
          // Resetea los colores al estado inicial si se rechazó
          isParamedicoSelected = false;
          waveColors = WaveColors.defaultWaveColors;
        });
      }
    }
  }

  void _selectClinica() {
    setState(() {
      isClinicaSelected = true;
      isParamedicoSelected = false;
      waveColors = WaveColors.redWaveColors;
    });
    showClinicaDialog();
  }

  void showClinicaDialog() {
    showDialog(
      context: context,
      builder: (context) => ClinicaDialog(
        onBack: () {
          setState(() {
            // Resetea los colores al estado inicial
            isParamedicoSelected = false;
            isClinicaSelected = false;
            waveColors = WaveColors.defaultWaveColors;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(),
          Column(
            children: [
              Header(
                screenWidth: screenWidth,
                mediaQuery: mediaQuery,
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
                child: SelectionOptions(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  isParamedicoSelected: isParamedicoSelected,
                  isClinicaSelected: isClinicaSelected,
                  onParamedicoTap: _selectParamedico,
                  onClinicaTap: _selectClinica,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
