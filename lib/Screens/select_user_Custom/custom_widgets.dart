import 'package:flutter/material.dart';

// Widget para la imagen de fondo
class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/backgroundGrey.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// Widget para el encabezado
class Header extends StatelessWidget {
  final double screenWidth;
  final MediaQueryData mediaQuery;

  const Header({
    super.key,
    required this.screenWidth,
    required this.mediaQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // ignore: deprecated_member_use
      color: Colors.white.withOpacity(0.0),
      padding: EdgeInsets.only(
        top: mediaQuery.padding.top + 55,
        bottom: mediaQuery.padding.bottom + 18,
      ),
      child: Center(
        child: Text(
          'REPORTNIC',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.07,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

// Widget para las opciones de selección
class SelectionOptions extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final bool isParamedicoSelected;
  final bool isClinicaSelected;
  final VoidCallback onParamedicoTap;
  final VoidCallback onClinicaTap;

  const SelectionOptions({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.isParamedicoSelected,
    required this.isClinicaSelected,
    required this.onParamedicoTap,
    required this.onClinicaTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onParamedicoTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: screenWidth * 0.4,
            width: screenWidth * 0.4,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: isParamedicoSelected ? Colors.blue : Colors.white,
            ),
            child: Icon(
              Icons.healing,
              size: screenWidth * 0.2,
              color: isParamedicoSelected ? Colors.white : Colors.black,
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
          onTap: onClinicaTap,
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
              color: isClinicaSelected ? Colors.white : Colors.black,
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
    );
  }
}
