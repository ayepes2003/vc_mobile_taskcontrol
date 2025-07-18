import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/providers/router_card_provider.dart';
import 'package:vc_taskcontrol/src/providers/theme_provider.dart';
import 'package:vc_taskcontrol/src/router/app_router.dart';
import 'package:vc_taskcontrol/src/storage/preferences/base_preferences.dart';
import 'package:vc_taskcontrol/src/storage/preferences/general_preferences.dart';
import 'src/services/api_config_service.dart';

import 'src/services/dio_servide.dart';
import 'src/services/connection_provider.dart';
import 'package:vc_taskcontrol/src/providers/data_provider.dart';
import 'src/myapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BasePreferences.init();

  // Personaliza el widget de error global
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: Colors.green,
        child: Center(
          child: Text(
            errorDetails.toString(),
            style: const TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
      ),
    );
  };

  // Inicializa SQLite para Windows/Linux
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Configura servicios de red y conexión
  final protocol = GeneralPreferences.apiProtocol;
  final base = GeneralPreferences.apiBase;
  final port = GeneralPreferences.apiPort;
  final endpoint = GeneralPreferences.apiEndpoint;
  final fullUrl = '$protocol://$base:$port$endpoint';
  final uri = Uri.tryParse(fullUrl);
  bool apiWasReset = false;
  if (uri == null || uri.host.isEmpty || uri.scheme.isEmpty) {
    GeneralPreferences.apiProtocol = 'http';
    GeneralPreferences.apiBase = '172.16.100.10';
    GeneralPreferences.apiPort = '8000';
    GeneralPreferences.apiEndpoint = '/api/v3';
    apiWasReset = true;
  }
  final dio = Dio();
  final apiConfig = ApiConfigService();
  await apiConfig.saveApiUrl(fullUrl);
  // uriApi='http://192.168.1.47:8000/api/v3'
  final dioService = DioService(dio, apiConfig);
  final connectionProvider = ConnectionProvider(dioService, apiConfig);
  final router = createRouter(connectionProvider);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => ThemeProvider(isDarkMode: GeneralPreferences.isDarkMode),
        ),
        ChangeNotifierProvider(create: (_) => connectionProvider),
        ChangeNotifierProvider(create: (_) => RouteCardProvider()),
        ChangeNotifierProvider(
          create:
              (_) =>
                  DataProvider()
                    ..loadMonitorData()
                    ..loadStepsFromJson()
                    ..loadSupervisorsFromJson()
                    ..loadProjectsFromJson()
                    ..loadSectionsFromJson()
                    ..loadOperatorsFromJson(),
        ),
      ],
      child: MyApp(router: router),
    ),
  );
}
