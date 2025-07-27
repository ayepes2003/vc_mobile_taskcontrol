import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/models/project.dart';
import 'package:vc_taskcontrol/src/models/section.dart';
import 'package:vc_taskcontrol/src/models/stepconfig.dart';
import 'package:vc_taskcontrol/src/models/supervisor.dart';
import 'package:vc_taskcontrol/src/models/operator.dart';

import 'package:vc_taskcontrol/src/pages/controltask/logic/step_widget_factory.dart';

class CentralContent extends StatelessWidget {
  final int selectionStep;
  final List<StepConfig> steps;

  // ⏭️ Mantén aún callbacks por ahora (luego podrías moverlos a Provider también)
  final ValueChanged<Supervisor> onSupervisorSelected;
  final ValueChanged<Project> onProjectSelected;
  final ValueChanged<Section> onSectionSelected;
  final ValueChanged<String> onSubsectionSelected;
  final ValueChanged<Operator> onOperatorSelected;
  final ValueChanged<String> onHourRangeSelected;

  const CentralContent({
    Key? key,
    required this.selectionStep,
    required this.steps,
    required this.onSupervisorSelected,
    required this.onProjectSelected,
    required this.onSectionSelected,
    required this.onSubsectionSelected,
    required this.onOperatorSelected,
    required this.onHourRangeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty || selectionStep < 0 || selectionStep >= steps.length) {
      return Center(child: CircularProgressIndicator());
    }

    final currentStepName = steps[selectionStep].name;

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child:
                getWidgetForStep(
                  stepName: currentStepName,
                  context: context,
                  onSupervisorSelected: onSupervisorSelected,
                  onProjectSelected: onProjectSelected,
                  onSectionSelected: onSectionSelected,
                  onSubsectionSelected: onSubsectionSelected,
                  onOperatorSelected: onOperatorSelected,
                  onHourRangeSelected: onHourRangeSelected,
                ) ??
                const SizedBox(),
          ),
        ],
      ),
    );
    // return Container(
    //   width: double.infinity,
    //   color: Colors.white,
    //   // Añade LayoutBuilder para capturar el espacio disponible
    //   child: LayoutBuilder(
    //     builder: (context, constraints) {
    //       return SingleChildScrollView(
    //         // padding inferior dinámico para dejar espacio con el teclado
    //         padding: EdgeInsets.only(
    //           bottom: MediaQuery.of(context).viewInsets.bottom,
    //           top: 10,
    //           left: 0,
    //           right: 0,
    //         ),
    //         child: ConstrainedBox(
    //           constraints: BoxConstraints(minHeight: constraints.maxHeight),
    //           child: IntrinsicHeight(
    //             child: Column(
    //               children: [
    //                 getWidgetForStep(
    //                       stepName: currentStepName,
    //                       context: context,
    //                       onSupervisorSelected: onSupervisorSelected,
    //                       onProjectSelected: onProjectSelected,
    //                       onSectionSelected: onSectionSelected,
    //                       onSubsectionSelected: onSubsectionSelected,
    //                       onOperatorSelected: onOperatorSelected,
    //                       onHourRangeSelected: onHourRangeSelected,
    //                     ) ??
    //                     const SizedBox(),
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}
