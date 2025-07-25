import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/models/shift/hour_range_response_model.dart';
import 'package:vc_taskcontrol/src/models/shift/shift_model.dart';
import 'package:vc_taskcontrol/src/services/dio_servide.dart';

class HourRangesProvider with ChangeNotifier {
  final DioService dioService;
  List<String> hourRanges = [];
  ShiftModel? currentShift;
  String? lastError;

  HourRangesProvider(this.dioService);
  Future<void> loadHourRangesFromApi({String? time}) async {
    try {
      // 1. Si `time` es null, genera la hora actual en formato HH:mm:ss
      final String hourParam =
          time ??
          "${DateTime.now().hour.toString().padLeft(2, '0')}"
              ":${DateTime.now().minute.toString().padLeft(2, '0')}"
              ":${DateTime.now().second.toString().padLeft(2, '0')}";

      // 2. Envía siempre `hourParam` como queryParameter
      final response = await dioService.getRequest(
        '/shift-hours',
        queryParameters: {'time': hourParam},
      );

      // 3. Parseo de la respuesta
      final data = (response['data']['data'] as List).first;
      final model = HourRangeResponseModel.fromJson(data);
      hourRanges = model.hourRanges;
      currentShift = model.shift;
      lastError = null;
    } catch (e) {
      lastError = 'Error al cargar hour ranges: $e';
      hourRanges = [];
      currentShift = null;
    }
    notifyListeners();
  }

  Future<void> OldloadHourRangesFromApi() async {
    try {
      print('Base URL actual de Dio: ${dioService.dio.options.baseUrl}');
      final now = DateTime.now();
      final String time =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:00";
      // final response = await dioService.getRequest('/shift-hours');
      final response = await dioService.getRequest(
        '/shift-hours',
        queryParameters: {'time': time},
      );
      // Accede al primer elemento del array de "data"
      final Map<String, dynamic> data =
          (response['data']['data'] as List).first;

      final model = HourRangeResponseModel.fromJson(data);
      hourRanges = model.hourRanges;
      currentShift = model.shift;
      lastError = null;
    } catch (e) {
      lastError = 'Error al cargar hour ranges: $e';
      hourRanges = [];
      currentShift = null;
    }
    notifyListeners();
  }
}
