import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/models/section.dart';
import 'package:vc_taskcontrol/src/services/dio_servide.dart';

class SectionsProvider with ChangeNotifier {
  final DioService dioService;
  List<Section> sections = [];
  String? lastError;

  SectionsProvider(this.dioService);

  Future<void> loadSectionsFromApi() async {
    try {
      final response = await dioService.getRequest('/sections');
      // final response = await dioService.getRequest('/sections_mok');
      print(
        'Base URL actual de Dio: ${dioService.dio.options.baseUrl}/sections',
      );

      // Asegúrate que la estructura de la respuesta sea la correcta
      // print(response['data']['data']);
      final dataList =
          (response['data']['data'] as List)
              .map((item) => Section.fromJson(item))
              .toList();
      sections = dataList;
      lastError = null;
      print(sections);
    } catch (e) {
      lastError = 'Error al cargar sections: $e';
      sections = [];
    }
    notifyListeners();
  }
}
