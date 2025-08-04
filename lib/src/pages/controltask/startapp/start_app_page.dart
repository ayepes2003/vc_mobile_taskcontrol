import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/route_data_provider.dart';
import 'package:vc_taskcontrol/src/services/connection_provider.dart';
import 'package:vc_taskcontrol/src/storage/preferences/general_preferences.dart';
import 'package:vc_taskcontrol/src/widgets/custom_app_bar.dart';

import 'package:vc_taskcontrol/src/widgets/menus/circular_start_menu.dart';
import 'package:vc_taskcontrol/src/widgets/menus/custom_menu_drawer.dart';

class StartAppPage extends StatefulWidget {
  const StartAppPage({super.key});

  @override
  State<StartAppPage> createState() => _StartAppPageState();
}

class _StartAppPageState extends State<StartAppPage> {
  @override
  Widget build(BuildContext context) {
    final isConnected = Provider.of<ConnectionProvider>(context).isConnected;
    final routeDataProvider = Provider.of<RouteDataProvider>(
      context,
      listen: false,
    );
    final appName = GeneralPreferences.appName;
    print(
      'Ids a insertar: supervisorId=${routeDataProvider.selectedSupervisorId}, '
      'sectionId=${routeDataProvider.selectedSectionId}, '
      'subsectionId=${routeDataProvider.selectedSubsection}, '
      'operatorid=${routeDataProvider.selectedOperatorId}',
    );
    return Scaffold(
      appBar: CustomAppBar(
        empresa: 'Milestone Muebles SAS',
        usuario: 'Usuario: ayepes2003@yahoo.es',
        fechaHora: '26/03/2025 20:00',
        isConnected: isConnected,
        title_app: 'Application Settings General',
      ),
      drawer: const CustomDrawerMenu(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 16.0,
          ), // Ajusta el valor al gusto
          child: Align(
            alignment: Alignment.bottomCenter,
            child: CircularStartMenuWidget(),
          ),
        ),
      ),
      // body: const CircularMenuWidget(),
    );
  }
}
