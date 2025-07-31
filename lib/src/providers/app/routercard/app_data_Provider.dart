import 'package:dio/dio.dart';

class AppApiProvider {
  final Dio dio;

  AppApiProvider(this.dio);

  Future<List<dynamic>> fetchOperarios() async {
    final response = await dio.get('/operarios');
    return response.data['data'];
  }

  // Continúa con métodos similares para cada uno de tus recursos/endpoints...
}
