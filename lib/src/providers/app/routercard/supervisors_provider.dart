import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/models/supervisor.dart';

import 'package:vc_taskcontrol/src/services/dio_servide.dart';

class SupervisorsProvider with ChangeNotifier {
  final DioService dioService;
  List<Supervisor> supervisors = [];
  String? lastError;

  SupervisorsProvider(this.dioService);

  Future<void> loadSupervisorsFromApi() async {
    try {
      final response = await dioService.getRequest('/supervisorys');
      print('Base URL actual de Dio: ${dioService.dio.options.baseUrl}');

      // Asegúrate que la estructura de la respuesta sea la correcta
      final dataList =
          (response['data']['data'] as List)
              .map((item) => Supervisor.fromJson(item))
              .toList();
      supervisors = dataList;
      lastError = null;
    } catch (e) {
      lastError = 'Error al cargar supervisores: $e';
      supervisors = [];
    }
    notifyListeners();
  }
}
