import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart'; // Asegúrate de importar también los paquetes necesarios

class SelectScreen extends StatelessWidget {
  const SelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'REPORTNIC',
            style: TextStyle(fontWeight: FontWeight.bold),
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
              const Center(
                child: Text(
                  '¿Quién usará la aplicación?',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: const Icon(
                        Icons.healing,
                        size: 80,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Paramédico',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: const Icon(
                        Icons.local_hospital,
                        size: 80,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Clínica',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            //WAVE
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
              size: const Size(double.infinity, 150),
              waveAmplitude: 20,
            ),
          ),
        ],
      ),
    );
  }
}
