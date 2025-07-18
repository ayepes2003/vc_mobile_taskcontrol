import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/models/project.dart';
import 'package:vc_taskcontrol/src/models/section.dart';
import 'package:vc_taskcontrol/src/models/stepconfig.dart';
import 'package:vc_taskcontrol/src/models/supervisor.dart';
import 'package:vc_taskcontrol/src/models/operator.dart'; // Importa el modelo Operator
import 'package:vc_taskcontrol/src/pages/controltask/widgets/operator/operator_grid_widget.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/steps/pieces_step_widget.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/steps/quantity_step_widget%20.dart';
// import 'package:vc_taskcontrol/src/pages/controltask/widgets/selection_summary_widget%20.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/subsections/subsection_grid_widget%20.dart';
import 'widgets_page.dart';

class CentralContent extends StatelessWidget {
  final int selectionStep;
  final List<StepConfig> steps;
  final List<Supervisor> supervisors;
  final int? selectedSupervisorId;
  final ValueChanged<Supervisor> onSupervisorSelected;
  final List<Project> projects;
  final int? selectedProjectId;
  final ValueChanged<Project> onProjectSelected;
  final List<Section> sections;
  final Section? selectedSection;
  final ValueChanged<Section> onSectionSelected;
  final List<Operator> operators;
  final int? selectedOperatorId;
  final ValueChanged<Operator> onOperatorSelected;
  // NUEVO PARA SUBSECCIONES
  final List<String> subsections;
  final String? selectedSubsection;
  final ValueChanged<String> onSubsectionSelected;
  final String selectedSupervisorName;
  final String selectedProjectName;
  final String selectedOperatorName;
  final String selectedSectionName;
  final String selectedSubsectionName;

  const CentralContent({
    Key? key,
    required this.selectionStep,
    required this.steps,
    required this.supervisors,
    required this.selectedSupervisorId,
    required this.onSupervisorSelected,
    required this.projects,
    required this.selectedProjectId,
    required this.onProjectSelected,
    required this.sections,
    required this.selectedSection,
    required this.onSectionSelected,
    required this.operators,
    required this.selectedOperatorId,
    required this.onOperatorSelected,
    required this.subsections, // NUEVO
    required this.selectedSubsection, // NUEVO
    required this.onSubsectionSelected,
    required this.selectedSupervisorName,
    required this.selectedProjectName,
    required this.selectedOperatorName,
    required this.selectedSectionName,
    required this.selectedSubsectionName, // NUEVO
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child:
          selectionStep == steps.indexWhere((step) => step.name == "supervisor")
              ? SupervisorGridWidget(
                supervisors: supervisors,
                selectedSupervisorId: selectedSupervisorId,
                onSelected: onSupervisorSelected,
              )
              : selectionStep ==
                  steps.indexWhere((step) => step.name == "project")
              ? ProjectListWidget(
                projects: projects,
                selectedProjectId: selectedProjectId,
                onSelected: onProjectSelected,
              )
              : selectionStep ==
                  steps.indexWhere((step) => step.name == "section")
              ? SectionGridWidget(
                sections: sections,
                selectedSection: selectedSection,
                onSelected: onSectionSelected,
              )
              : selectionStep ==
                  steps.indexWhere((step) => step.name == "subsection")
              ? SubsectionGridWidget(
                subsections: subsections,
                selectedSubsection: selectedSubsection,
                onSelected: onSubsectionSelected,
              )
              : selectionStep ==
                  steps.indexWhere((step) => step.name == "operator")
              ? OperatorGridWidget(
                operators: operators,
                selectedOperatorId: selectedOperatorId,
                onSelected: onOperatorSelected,
                selectedColor: Colors.orange,
                selectedTextColor: Colors.white,
              )
              : selectionStep ==
                  steps.indexWhere((step) => step.name == "quantity")
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // SelectionSummaryWidget(
                  //   supervisor: selectedSupervisorName,
                  //   project: selectedProjectName,
                  //   operatorName: selectedOperatorName,
                  //   section: selectedSectionName,
                  //   subsection: selectedSubsectionName,
                  // ),
                  const SizedBox(height: 5),
                  QuantityStepWidget(
                    supervisor: selectedSupervisorName,
                    project: selectedProjectName,
                    operatorName: selectedOperatorName,
                    section: selectedSectionName,
                    subsection: selectedSubsectionName,
                  ),
                ],
              )
              : selectionStep ==
                  steps.indexWhere((step) => step.name == "pieces")
              ? PiecesStepWidget(onCameraPressed: () {})
              : (selectionStep == steps.length - 1
                  ? const SettingsWidget()
                  : StepContentArea(stepTitle: steps[selectionStep].label)),
    );
  }
}
