import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:vc_taskcontrol/src/models/operator.dart';
import 'package:vc_taskcontrol/src/models/project.dart';
import 'package:vc_taskcontrol/src/models/section.dart';
import 'package:vc_taskcontrol/src/models/stepconfig.dart';
import 'package:vc_taskcontrol/src/models/supervisor.dart' show Supervisor;
import 'package:vc_taskcontrol/src/pages/controltask/widgets/central_content.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/menus/side_menu_widget.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/hour_ranges_provider.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/operators_provider.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/sections_provider.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/steps_provider.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/supervisors_provider.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/mock_data_provider.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/route_data_provider.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/router_card_provider.dart';
import 'package:vc_taskcontrol/src/services/connection_provider.dart';
import 'package:vc_taskcontrol/src/storage/preferences/app_preferences.dart';
import 'package:vc_taskcontrol/src/storage/routes/route_database.dart';
import 'package:vc_taskcontrol/src/widgets/custom_app_bar.dart';
import 'widgets/widgets_page.dart';

class ControltaskBasePage extends StatefulWidget {
  const ControltaskBasePage({Key? key}) : super(key: key);

  @override
  State<ControltaskBasePage> createState() => _ControltaskBasePageState();
}

class _ControltaskBasePageState extends State<ControltaskBasePage> {
  int selectionStep = 0;

  late List<StepConfig> steps; // 👈 Nueva propiedad de estado

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 🔄 Hidratación de sección y subsección desde SharedPreferences
      // Provider.of<RouteCardProvider>(
      //   context,
      //   listen: false,
      // ).loadRoutesFromCSV();

      Provider.of<RouteCardProvider>(
        context,
        listen: false,
      ).loadRoutesFromApi();

      final routeProvider = Provider.of<RouteDataProvider>(
        context,
        listen: false,
      );

      // Simulación: carga desde SharedPreferences o algún servicio local
      final savedSection = await AppPreferences.getSection(); // String
      final savedSubsection = await AppPreferences.getSubsection(); // String

      // 👉 Ahora tú buscas en tu lista de secciones (del DataProvider)
      final allSections =
          Provider.of<MockDataProvider>(context, listen: false).sections;
      final matchedSection = allSections.firstWhereOrNull(
        (section) => section.sectionName == savedSection,
      );

      if (matchedSection != null) {
        routeProvider.setSelectedSection(matchedSection);
        if (savedSubsection != null) {
          routeProvider.setSelectedSubsection(savedSubsection);
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dataProvider = Provider.of<MockDataProvider>(context);
    steps = dataProvider.steps;
  }

  void onSubsectionSelected(String subsection) async {
    final routeProvider = Provider.of<RouteDataProvider>(
      context,
      listen: false,
    );

    routeProvider.setSelectedSubsection(subsection);
    routeProvider.setSubsection(subsection);
    await AppPreferences.setSubsection(subsection);

    setState(() {
      selectionStep = getNextStepIndex(steps, "subsection");
    });
  }

  Future<void> _handleRefresh(BuildContext context) async {
    await AppPreferences.clearAll();
    Provider.of<RouteDataProvider>(context, listen: false).clear();

    Provider.of<SupervisorsProvider>(
      context,
      listen: false,
    ).loadSupervisorsFromApi();
    //hora hora
    Provider.of<HourRangesProvider>(
      context,
      listen: false,
    ).loadHourRangesFromApi();
    Provider.of<SectionsProvider>(context, listen: false).loadSectionsFromApi();
    Provider.of<OperatorsProvider>(
      context,
      listen: false,
    ).loadOperatorsFromApi();

    // rutas
    Provider.of<RouteCardProvider>(context, listen: false).loadRoutesFromApi();
    await RouteDatabase().clearAllReads();
    // await Provider.of<RouteCardProvider>(
    //   context,
    //   listen: false,
    // ).loadRoutesFromLocal();

    await Provider.of<RouteCardProvider>(
      context,
      listen: false,
    ).loadRecentReads();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Actualizando datos servidor y limpiando sesión'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<MockDataProvider>(context);
    final stepsProvider = Provider.of<StepsProvider>(context);
    final List<StepConfig> steps = stepsProvider.steps;

    // final supervisorsProvider = Provider.of<SupervisorsProvider>(context);
    // final List<Supervisor> supervisors = supervisorsProvider.supervisors;

    // final List<StepConfig> steps = dataProvider.steps;
    // final List<Supervisor> supervisors = dataProvider.supervisors;

    final provider = context.watch<RouteCardProvider>();
    final routeData = context.watch<RouteDataProvider>();

    // Obtén el último registro leído (si hay)
    final lastRead =
        provider.recentReads.isNotEmpty ? provider.recentReads.first : null;

    final List<Project> projects = dataProvider.projects;
    final List<Section> sections = dataProvider.sections;
    final List<Operator> operators = dataProvider.operators;
    final List<String> subsections =
        routeData.selectedSection?.subsections ?? [];

    final isConnected = Provider.of<ConnectionProvider>(context).isConnected;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        empresa: 'Milestone Muebles SAS',
        usuario: 'Usuario: ayepes2003@yahoo.es',
        fechaHora: '26/03/2025 20:00',
        isConnected: isConnected,
        title_app: 'Production Time Control',
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
                    onSupervisorSelected: (supervisor) async {
                      final routeProvider = Provider.of<RouteDataProvider>(
                        context,
                        listen: false,
                      );
                      routeProvider.setSupervisor(supervisor.name);
                      routeProvider.setSelectedSupervisorId(
                        supervisor.id,
                      ); // ✅ nuevo
                      await AppPreferences.setSupervisor(supervisor.name);

                      setState(() {
                        selectionStep = getNextStepIndex(steps, "supervisor");
                      });
                    },
                    onProjectSelected: (project) {
                      final routeProvider = Provider.of<RouteDataProvider>(
                        context,
                        listen: false,
                      );
                      routeProvider.setSelectedProjectId(project.id); // ✅ nuevo
                      setState(() {
                        selectionStep = getNextStepIndex(steps, "project");
                      });
                    },
                    onSectionSelected: (section) async {
                      final routeProvider = Provider.of<RouteDataProvider>(
                        context,
                        listen: false,
                      );

                      routeProvider.setSelectedSection(
                        section,
                      ); // actualizas ambos
                      routeProvider.setSection(
                        section.sectionName,
                      ); // si quieres guardar el nombre “puro”

                      await AppPreferences.setSection(section.sectionName);
                      setState(() {
                        selectionStep = steps.indexWhere(
                          (step) => step.name == "subsection",
                        );
                      });
                    },

                    onSubsectionSelected: (subsection) async {
                      final routeProvider = Provider.of<RouteDataProvider>(
                        context,
                        listen: false,
                      );

                      routeProvider.setSelectedSubsection(
                        subsection,
                      ); // 👈 ahora lo almacena bien
                      routeProvider.setSubsection(
                        subsection,
                      ); // 👈 si usas el valor textual también

                      await AppPreferences.setSubsection(subsection);
                      setState(() {
                        selectionStep = getNextStepIndex(steps, "subsection");
                      });
                    },
                    onOperatorSelected: (operator) async {
                      final routeProvider = Provider.of<RouteDataProvider>(
                        context,
                        listen: false,
                      );

                      routeProvider.setOperatorName(operator.name);
                      routeProvider.setSelectedOperatorId(
                        operator.id,
                      ); // ✅ Nuevo

                      await AppPreferences.setOperator(operator.name);
                      setState(() {
                        selectionStep = getNextStepIndex(steps, "operator");
                      });
                    },
                    onHourRangeSelected: (range) async {
                      final routeProvider = context.read<RouteDataProvider>();
                      routeProvider.setSelectedHourRange(range);

                      setState(() {
                        selectionStep = getNextStepIndex(steps, 'hour_range');
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 220,
            color: Colors.grey[100],
            child: Column(
              children: [
                Row(
                  children: [
                    Tooltip(
                      message: "Refrescar datos y limpiar sesión",
                      child: IconButton(
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.red,
                          size: 30,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _handleRefresh(context),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 5),
                SummaryCardWidget(lastEntry: LastEntryWidget()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


 //   ElevatedButton.icon(
                    //     icon: Icon(Icons.refresh, color: Colors.red),
                    //     // icon: Icon(Icons.delete_forever, color: Colors.red),
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.white,
                    //       foregroundColor: Colors.red,
                    //     ),
                    //     label: Text('Refresh'),
                    //     onPressed: () async {
                    //       await AppPreferences.clearAll();
                    //       // Provider.of<RouteDataProvider>(
                    //       //   context,
                    //       //   listen: false,
                    //       // ).clear();
                    //       Provider.of<SupervisorsProvider>(
                    //         context,
                    //         listen: false,
                    //       ).loadSupervisorsFromApi();

                    //       Provider.of<HourRangesProvider>(
                    //         context,
                    //         listen: false,
                    //       ).loadHourRangesFromApi();

                    //       Provider.of<SectionsProvider>(
                    //         context,
                    //         listen: false,
                    //       ).loadSectionsFromApi();

                    //       Provider.of<OperatorsProvider>(
                    //         context,
                    //         listen: false,
                    //       ).loadOperatorsFromApi();

                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         SnackBar(
                    //           content: Text('Preferencias y sesión borradas'),
                    //         ),
                    //       );
                    //     },
                    //   ),