import 'package:dio/dio.dart';
import 'package:vc_taskcontrol/src/models/product.dart';
import 'package:vc_taskcontrol/src/services/api_config_service.dart';
import 'package:vc_taskcontrol/src/storage/sqlite_product_storage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DioService {
  final Dio _dio;
  final ApiConfigService _apiConfig;
  Dio get dio => _dio;
  DioService(this._dio, this._apiConfig);

  DioService.withConfig()
    : _dio = Dio(
        BaseOptions(
          baseUrl: '', // Se obtendrá desde ApiConfigService
          connectTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
          sendTimeout: const Duration(seconds: 10),
          responseType: ResponseType.json,
        ),
      ),
      _apiConfig = ApiConfigService();

  Future<void> initConfig() async {
    final apiUrl = await _apiConfig.getApiUrl();
    _dio.options.baseUrl = apiUrl;

    // Agregar encabezados
    _dio.options.headers = {
      'Authorization': 'Bearer YOUR_TOKEN_HERE', // Reemplaza con tu token real
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'DioClient/1.0',
      'X-Device-Id':
          'YOUR_DEVICE_ID', // Reemplaza con tu ID de dispositivo real
    };

    // Agregar interceptores para manejar encabezados y respuestas
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Puedes agregar más lógica aquí para manejar las peticiones
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('Error: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getRequest(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      await initConfig();
      final response = await _dio.get(path, queryParameters: queryParameters);
      // print(path);
      if (response.statusCode == 200) {
        return {'statusCode': response.statusCode, 'data': response.data};
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Received invalid status code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Map<String, dynamic>> postRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      await initConfig();
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'statusCode': response.statusCode, 'data': response.data};
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Received invalid status code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Map<String, dynamic>> putRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      await initConfig();
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return {'statusCode': response.statusCode, 'data': response.data};
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Received invalid status code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Map<String, dynamic>> deleteRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      await initConfig();
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 204) {
        return {'statusCode': response.statusCode, 'data': response.data};
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Received invalid status code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<void> sendDataToServer(List<Map<String, dynamic>> data) async {
    final apiUrl = await _apiConfig.getApiUrl();
    try {
      final response = await _dio.post('$apiUrl/items', data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Datos enviados correctamente');
      } else {
        print('Error al enviar datos');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
    }
  }

  Future<bool> checkApiConnection() async {
    try {
      await initConfig();
      print('${_dio.options.baseUrl}/health');
      final response = await _dio.get('${_dio.options.baseUrl}/health');
      print(response.statusCode);

      return true;
      //  response.statusCode == 200;
    } catch (e) {
      print('Error al verificar conexión con la API: $e');
      return false;
    }
  }

  DioException _handleDioException(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.cancel:
          return DioException(
            requestOptions: error.requestOptions,
            type: DioExceptionType.cancel,
            error: 'Request to the server was cancelled.',
          );
        case DioExceptionType.connectionTimeout:
          return DioException(
            requestOptions: error.requestOptions,
            type: DioExceptionType.connectionTimeout,
            error: 'Connection timed out.',
          );
        case DioExceptionType.receiveTimeout:
          return DioException(
            requestOptions: error.requestOptions,
            type: DioExceptionType.receiveTimeout,
            error: 'Receiving timeout occurred.',
          );
        case DioExceptionType.sendTimeout:
          return DioException(
            requestOptions: error.requestOptions,
            type: DioExceptionType.sendTimeout,
            error: 'Request send timeout.',
          );
        case DioExceptionType.badResponse:
          return DioException(
            requestOptions: error.requestOptions,
            response: error.response,
            type: DioExceptionType.badResponse,
            error: 'Bad response: ${error.response?.statusCode}',
          );
        case DioExceptionType.unknown:
          return DioException(
            requestOptions: error.requestOptions,
            type: DioExceptionType.unknown,
            error: error.message,
          );
        default:
          return DioException(
            requestOptions: error.requestOptions,
            type: DioExceptionType.unknown,
            error: 'Unexpected error occurred.',
          );
      }
    } else {
      return DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.unknown,
        error: 'Unexpected error occurred.',
      );
    }
  }

  Future<void> fetchProducts(Database db) async {
    try {
      final productStorage = SqliteProductStorage(db);
      await productStorage.deleteAllProduct();
      final response = await getRequest('/pos_products');
      print(response.toString());

      final products =
          (response['data'] as List)
              .map((product) => Product.fromJson(product))
              .toList();

      for (final product in products) {
        await productStorage.addProduct(product.toJson());
        print("Insertando productos");
      }
    } catch (e) {
      print('Error al obtener productos: $e');
      throw Exception('No se pudieron cargar los productos: $e');
    }
  }
}
