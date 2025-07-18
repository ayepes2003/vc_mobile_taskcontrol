import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/models/operator.dart';
import 'package:vc_taskcontrol/src/models/project.dart';
import 'package:vc_taskcontrol/src/models/section.dart';
import 'package:vc_taskcontrol/src/models/stepconfig.dart';
import 'package:vc_taskcontrol/src/models/supervisor.dart' show Supervisor;
import 'package:vc_taskcontrol/src/pages/controltask/widgets/central_content.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/menus/side_menu_widget.dart';
import 'package:vc_taskcontrol/src/providers/data_provider.dart';
import 'package:vc_taskcontrol/src/providers/router_card_provider.dart';
import 'package:vc_taskcontrol/src/services/connection_provider.dart';
import 'package:vc_taskcontrol/src/widgets/custom_app_bar.dart';
import 'widgets/widgets_page.dart';
import 'dart:convert';
import 'package:collection/collection.dart';

class ControltaskBasePage extends StatefulWidget {
  const ControltaskBasePage({Key? key}) : super(key: key);

  @override
  State<ControltaskBasePage> createState() => _ControltaskBasePageState();
}

class _ControltaskBasePageState extends State<ControltaskBasePage> {
  int selectionStep = 0;
  int? selectedProjectId;
  int? selectedSupervisorId;
  int? selectedOperatorId;
  Operator? selectedOperator;

  String? selectedSubsection;
  Section? selectedSection;

  Map<String, String> selectedValues = {
    "Supervisor": "Jorge",
    "Proyecto": "Proyecto X",
    "Sección": "Corte",
    "Subsección": "Mesa 2",
    "Cantidad": "25",
  };

  int getNextStepIndex(List<StepConfig> steps, String currentStepName) {
    final currentStep = steps.firstWhere(
      (step) => step.name == currentStepName,
    );
    final nextStepId = currentStep.stepId + 1;
    final nextStep = steps.firstWhere(
      (step) => step.stepId == nextStepId,
      orElse: () => steps.last,
    );
    return steps.indexOf(nextStep);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RouteCardProvider>(
        context,
        listen: false,
      ).loadRoutesFromCSV();
    });
  }

  void onSubsectionSelected(String subsection) {
    setState(() {
      selectedSubsection = subsection;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final List<StepConfig> steps = dataProvider.steps;
    final List<Supervisor> supervisors = dataProvider.supervisors;
    final List<Project> projects = dataProvider.projects;
    final List<Section> sections = dataProvider.sections;
    final List<Operator> operators = dataProvider.operators;
    final List<String> subsections = selectedSection?.subsections ?? [];
    final String selectedSubsectionName = selectedSubsection ?? '';

    if (subsections.isEmpty) {
      selectedSubsection = null;
    }

    final Supervisor? selectedSupervisor = supervisors.firstWhereOrNull(
      (s) => s.id == selectedSupervisorId,
    );
    final String selectedSupervisorName = selectedSupervisor?.name ?? '';

    final Project? selectedProject = projects.firstWhereOrNull(
      (p) => p.id == selectedProjectId,
    );
    final String selectedProjectName = selectedProject?.projectName ?? '';

    ;
    final String selectedSectionName = selectedSection?.sectionName ?? '';

    Operator? selectedOperator = operators.firstWhereOrNull(
      (o) => o.id == selectedOperatorId,
    );
    final String selectedOperatorName = selectedOperator?.name ?? '';
    final isConnected = Provider.of<ConnectionProvider>(context).isConnected;

    return Scaffold(
      appBar: CustomAppBar(
        empresa: 'Milestone Muebles SAS',
        usuario: 'Usuario: ayepes2003@yahoo.es',
        fechaHora: '26/03/2025 20:00',
        isConnected: isConnected,
        title_app: 'Manual Time Control Production',
      ),
      body: Row(
        children: [
          SideMenuWidget(
            steps: steps,
            selectionStep: selectionStep,
            onStepSelected: (index) {
              setState(() {
                selectionStep = index;
              });
            },
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: CentralContent(
                    selectionStep: selectionStep,
                    steps: steps,
                    supervisors: supervisors,
                    selectedSupervisorId: selectedSupervisorId,
                    onSupervisorSelected: (supervisor) {
                      setState(() {
                        selectedSupervisorId = supervisor.id;
                        selectionStep = getNextStepIndex(steps, "supervisor");
                      });
                    },
                    projects: projects,
                    selectedProjectId: selectedProjectId,
                    onProjectSelected: (project) {
                      setState(() {
                        selectedProjectId = project.id;
                        selectionStep = getNextStepIndex(steps, "project");
                      });
                    },
                    sections: sections,
                    selectedSection: selectedSection,
                    onSectionSelected: (section) {
                      setState(() {
                        selectedSection = section;
                        selectedSubsection = null;
                        selectionStep = steps.indexWhere(
                          (step) => step.name == "subsection",
                        );
                      });
                    },
                    subsections: subsections,
                    selectedSubsection: selectedSubsection,
                    onSubsectionSelected: (subsection) {
                      setState(() {
                        selectedSubsection = subsection;
                        selectionStep = getNextStepIndex(steps, "subsection");
                      });
                    },
                    selectedSupervisorName: selectedSupervisorName,
                    selectedProjectName: selectedProjectName,
                    selectedOperatorName: selectedOperatorName,
                    selectedSectionName: selectedSectionName,
                    selectedSubsectionName: selectedSubsectionName,
                    operators: operators,
                    selectedOperatorId: selectedOperatorId,
                    onOperatorSelected: (operator) {
                      setState(() {
                        selectedOperatorId = operator.id;
                        selectedOperator = operator;
                        selectionStep = getNextStepIndex(steps, "operator");
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 255,
            color: Colors.grey[100],
            child: SummaryCardWidget(
              project: selectedProjectName,
              supervisor: selectedSupervisorName,
              operatorName: selectedOperatorName,
              section: selectedSectionName,
              subsection: selectedSubsectionName,
              estimatedQuantity: 120,
              realQuantity: 100,
              lastEntry: LastEntryWidget(
                supervisor: 'Jorge',
                operator: 'Ana',
                section: 'Corte',
                subsection: 'Mesa 2',
                quantity: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
