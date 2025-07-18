import 'package:flutter/material.dart';

class StepHeaderHorizontal extends StatelessWidget {
  final List<String> steps;
  final int selectionStep;
  final Map<String, String> selectedValues;
  final Function(int) onStepTap;

  const StepHeaderHorizontal({
    Key? key,
    required this.steps,
    required this.selectionStep,
    required this.selectedValues,
    required this.onStepTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: steps.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectionStep;
          final value = selectedValues[steps[index]] ?? '—';

          return GestureDetector(
            onTap: () => onStepTap(index),
            child: Container(
              width: 120,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green[200] : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? Colors.green : Colors.grey[400]!,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    steps[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.green[900] : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
