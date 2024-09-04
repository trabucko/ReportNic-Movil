import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
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

  void _selectParamedico() {
    setState(() {
      isParamedicoSelected = true;
      isClinicaSelected = false;
      waveColors = WaveColors.blueWaveColors;
    });
    _showParamedicoDialog();
  }

  void _selectClinica() {
    setState(() {
      isClinicaSelected = true;
      isParamedicoSelected = false;
      waveColors = WaveColors.redWaveColors;
    });
    _showClinicaDialog();
  }

  void _showParamedicoDialog() {
    showDialog(
      context: context,
      builder: (context) => ParamedicoDialog(
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

  void _showClinicaDialog() {
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
          Align(
            alignment: Alignment.bottomCenter,
            child: WaveWidget(
              config: CustomConfig(
                colors: waveColors,
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
