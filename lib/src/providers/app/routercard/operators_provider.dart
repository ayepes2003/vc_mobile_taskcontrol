import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/models/operator.dart';
import 'package:vc_taskcontrol/src/services/dio_servide.dart';

class OperatorsProvider with ChangeNotifier {
  final DioService dioService;
  List<Operator> operators = [];
  String? lastError;

  OperatorsProvider(this.dioService);

  Future<void> loadOperatorsFromApi() async {
    try {
      print('Base URL actual de Dio: ${dioService.dio.options.baseUrl}');
      final response = await dioService.getRequest('/operators');
      final dataList =
          (response['data']['data'] as List)
              .map((item) => Operator.fromJson(item))
              .toList();
      operators = dataList;
      lastError = null;
    } catch (e) {
      lastError = 'Error al cargar operators: $e';
      operators = [];
    }
    notifyListeners();
  }
}
