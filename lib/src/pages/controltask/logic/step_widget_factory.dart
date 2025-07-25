import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/models/operator.dart';
import 'package:vc_taskcontrol/src/models/project.dart';
import 'package:vc_taskcontrol/src/models/section.dart';
import 'package:vc_taskcontrol/src/models/supervisor.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/hour/hour_grid_widget.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/operator/operator_grid_widget.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/steps/pieces_step_widget.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/steps/quantity_step_widget%20.dart';

import 'package:vc_taskcontrol/src/pages/controltask/widgets/subsections/subsection_grid_widget%20.dart';

import 'package:vc_taskcontrol/src/pages/controltask/widgets/widgets_page.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/providers/route_data_provider.dart';

Widget? getWidgetForStep({
  required String stepName,
  required BuildContext context,
  required ValueChanged<Supervisor> onSupervisorSelected,
  required ValueChanged<Project> onProjectSelected,
  required ValueChanged<Section> onSectionSelected,
  required ValueChanged<String> onSubsectionSelected,
  required ValueChanged<Operator> onOperatorSelected,
  required ValueChanged<String> onHourRangeSelected,
}) {
  final routeProvider = context.watch<RouteDataProvider>();

  switch (stepName) {
    case 'supervisor':
      return SupervisorGridWidget(onSelected: onSupervisorSelected);

    case 'section':
      return SectionGridWidget(onSelected: onSectionSelected);

    case 'subsection':
      return SubsectionGridWidget(onSelected: onSubsectionSelected);

    case 'operator':
      return OperatorGridWidget(
        onSelected: onOperatorSelected,
        selectedColor: Colors.orange,
        selectedTextColor: Colors.white,
      );

    case 'hour_range':
      return HourRangeGridWidget(onSelected: onHourRangeSelected);

    case 'quantity':
      return const QuantityStepWidget();

    case 'pieces':
      return PiecesStepWidget(onCameraPressed: () {});

    case 'settings':
      return const SettingsWidget();

    default:
      return StepContentArea(stepTitle: stepName.toUpperCase());
  }
}
