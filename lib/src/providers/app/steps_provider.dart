import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/models/stepconfig.dart';
import 'package:vc_taskcontrol/src/services/dio_servide.dart';

class StepsProvider with ChangeNotifier {
  final DioService dioService;
  List<StepConfig> steps = [];
  String? lastError;

  StepsProvider(this.dioService);

  Future<void> loadStepsFromApi() async {
    try {
      print('Base URL actual de Dio: ${dioService.dio.options.baseUrl}');
      final response = await dioService.getRequest('/steps');

      // Asegúrate que la estructura de la respuesta sea la correcta
      final dataList =
          (response['data']['data'] as List)
              .map((item) => StepConfig.fromJson(item))
              .toList();
      steps = dataList;
      lastError = null;
    } catch (e) {
      lastError = 'Error al cargar steps: $e';
      steps = [];
    }
    notifyListeners();
  }
}
