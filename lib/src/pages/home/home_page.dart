import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/services/connection_provider.dart';
import 'package:vc_taskcontrol/src/storage/preferences/general_preferences.dart';
import 'package:vc_taskcontrol/src/widgets/custom_app_bar.dart';
import 'package:vc_taskcontrol/src/widgets/menus/circular_menu.dart';
import 'package:vc_taskcontrol/src/widgets/menus/custom_menu_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final isConnected = Provider.of<ConnectionProvider>(context).isConnected;
    final appName = GeneralPreferences.appName;
    return Scaffold(
      appBar: CustomAppBar(
        empresa: 'Milestone Muebles SAS',
        usuario: 'Usuario: ayepes2003@yahoo.es',
        fechaHora: '26/03/2025 20:00',
        isConnected: isConnected,
        title_app: '$appName',
      ),
      drawer: const CustomDrawerMenu(),
      body: // Ejemplo solo para el menú
          SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 16.0,
          ), // Ajusta el valor al gusto
          child: Align(
            alignment: Alignment.bottomCenter,
            child: CircularMenuWidget(),
          ),
        ),
      ),
      // body: const CircularMenuWidget(),
    );
  }
}
