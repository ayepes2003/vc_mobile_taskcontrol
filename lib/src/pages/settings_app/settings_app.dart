import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/pages/settings_app/widgets/api_rest.dart';
import 'package:vc_taskcontrol/src/pages/settings_app/widgets/websocket.dart';
import 'package:vc_taskcontrol/src/services/connection_provider.dart';
import 'package:vc_taskcontrol/src/storage/preferences/general_preferences.dart';
import 'package:vc_taskcontrol/src/widgets/custom_app_bar.dart';
import 'package:vc_taskcontrol/src/widgets/menus/custom_menu_drawer.dart';

class SettingsAppPage extends StatefulWidget {
  const SettingsAppPage({super.key});

  @override
  State<SettingsAppPage> createState() => _SettingsAppPageState();
}

class _SettingsAppPageState extends State<SettingsAppPage> {
  bool useHttps = false;
  final TextEditingController ipController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController pathController = TextEditingController(
    text: '/api/v3',
  );

  bool useWss = false;
  final TextEditingController wsIpController = TextEditingController();
  final TextEditingController wsPortController = TextEditingController();
  final TextEditingController wsPathController = TextEditingController(
    text: '/',
  );

  @override
  void initState() {
    super.initState();

    // Protocolo (http/https)
    useHttps = GeneralPreferences.apiProtocol == 'https';

    // API REST
    ipController.text = GeneralPreferences.apiBase;
    portController.text = GeneralPreferences.apiPort;
    pathController.text = GeneralPreferences.apiEndpoint;
  }

  @override
  void dispose() {
    ipController.dispose();
    portController.dispose();
    pathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = Provider.of<ConnectionProvider>(context).isConnected;
    final moduleName = GeneralPreferences.currentModule;
    final appName = GeneralPreferences.appName;

    return Scaffold(
      appBar: CustomAppBar(
        empresa: 'Milestone Muebles SAS',
        usuario: 'Usuario: ayepes2003@yahoo.es',
        fechaHora: '26/03/2025 20:00',
        isConnected: isConnected,
        title_app: '$appName\n($moduleName)',
      ),
      drawer: const CustomDrawerMenu(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ApiRestConfigCard(), WebSocketConfigCard()],
            ),
          ),
        ),
      ),
    );
  }
}
