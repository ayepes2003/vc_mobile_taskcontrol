import 'package:flutter/material.dart';

class StepContentArea extends StatelessWidget {
  final String stepTitle;

  const StepContentArea({Key? key, required this.stepTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Contenido para: $stepTitle',
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }
}
