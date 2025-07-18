import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/services/connection_provider.dart';
import 'package:vc_taskcontrol/src/storage/preferences/general_preferences.dart';
import 'package:vc_taskcontrol/src/widgets/custom_app_bar.dart';
import 'package:vc_taskcontrol/src/widgets/menus/circular_menu.dart';
import 'package:vc_taskcontrol/src/widgets/menus/custom_menu_drawer.dart';
import 'package:vc_taskcontrol/src/widgets/menus/custom_radial_menu.dart';

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
      body: const CircularMenuWidget(),
    );
  }
}


// body: Center(
      //   child:
      //       showGlassMenu
      //           ? const GlassMenu()
      //           : const CustomRadialMenu(), // Cambia el nombre si tu widget radial tiene otro nombre
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       showGlassMenu = !showGlassMenu;
      //     });
      //   },
      //   child: const Icon(Icons.swap_horiz),
      //   tooltip: 'Cambiar menú',
      // ),
      // import 'package:vc_taskcontrol/src/widgets/menus/glass_menu.dart';