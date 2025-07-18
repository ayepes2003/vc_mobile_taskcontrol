import 'package:flutter/material.dart';
import 'package:string_to_icon/string_to_icon.dart';
import 'package:vc_taskcontrol/src/models/stepconfig.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/widgets_page.dart';

class SideMenuWidget extends StatelessWidget {
  final List<StepConfig> steps;
  final int selectionStep;
  final ValueChanged<int> onStepSelected;

  const SideMenuWidget({
    Key? key,
    required this.steps,
    required this.selectionStep,
    required this.onStepSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 245,
      color: Theme.of(context).colorScheme.onPrimary, // Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(steps.length, (index) {
          final step = steps[index];
          return SideMenuButton(
            label: step.label,
            icon: step.icon,
            isSelected: index == selectionStep,
            stepNumber: step.stepId,
            selectedColor: step.selectedColor,
            selectedTextColor: step.selectedTextColor,
            onTap: () => onStepSelected(index),
          );
        }),
      ),
    );
  }
}
