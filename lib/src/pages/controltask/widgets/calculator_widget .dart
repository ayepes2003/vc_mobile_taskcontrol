import 'package:flutter/material.dart';

class CalculatorWidget extends StatelessWidget {
  final String displayValue;
  final void Function(String) onButtonPressed;

  const CalculatorWidget({
    Key? key,
    required this.displayValue,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonLabels = [
      '7',
      '8',
      '9',
      '÷',
      'MC',
      '4',
      '5',
      '6',
      '×',
      '',
      '1',
      '2',
      '3',
      '−',
      '',
      '0',
      '.',
      '=',
      '+',
      '',
      'DEL',
      'C',
      'OK',
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Display
        Container(
          width: double.infinity,
          height: 80,
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            displayValue,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 24),
        // Botonera
        GridView.count(
          crossAxisCount: 5,
          shrinkWrap: true,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children:
              buttonLabels.map((label) {
                if (label.isEmpty) {
                  return const SizedBox.shrink();
                }
                String textLabel = label;
                if (label == 'DEL') textLabel = 'Borrar';
                if (label == 'C') textLabel = 'Limpiar';
                if (label == 'OK') textLabel = 'Aceptar';
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 80),
                    textStyle: const TextStyle(fontSize: 28),
                  ),
                  onPressed: () => onButtonPressed(label),
                  child: Text(textLabel),
                );
              }).toList(),
        ),
      ],
    );
  }
}
