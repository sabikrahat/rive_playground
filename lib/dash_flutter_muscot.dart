import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class DashFlutterMuscot extends StatefulWidget {
  const DashFlutterMuscot({super.key, this.width = 220.0, this.height = 220.0});

  final double width;
  final double height;

  @override
  State<DashFlutterMuscot> createState() => _DashFlutterMuscotState();
}

class _DashFlutterMuscotState extends State<DashFlutterMuscot> {
  Artboard? riveArtboard;
  SMIBool? isDance;
  SMITrigger? isLookUp;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/dash_flutter_muscot.riv').then(
      (data) async {
        try {
          final file = RiveFile.import(data);
          final artboard = file.mainArtboard;
          final controller =
              StateMachineController.fromArtboard(artboard, 'birb');
          if (controller != null) {
            artboard.addController(controller);
            isDance = controller.findSMI('dance');
            isLookUp = controller.findSMI('look up');
          }
          setState(() => riveArtboard = artboard);
        } catch (e) {
          log('Dash Flutter Muscot Error: $e');
        }
      },
    );
  }

  void toggleDance(bool v) => setState(() => isDance!.value = v);

  void toggleLook(bool v) => isLookUp!.value = v;

  @override
  Widget build(BuildContext context) {
    return riveArtboard == null
        ? Center(child: CircularProgressIndicator())
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              SizedBox(
                height: widget.height,
                width: widget.width,
                child: Rive(artboard: riveArtboard!),
              ),
              Row(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => toggleDance(!isDance!.value),
                    child: Text(isDance!.value ? 'Stop Dancing' : 'Dance'),
                  ),
                  ElevatedButton(
                    onPressed: () => toggleLook(!isLookUp!.value),
                    child: Text('Toggle Look'),
                  ),
                ],
              ),
            ],
          );
  }
}
