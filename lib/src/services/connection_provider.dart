import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/services/api_config_service.dart';
import 'package:vc_taskcontrol/src/services/dio_servide.dart';

class ConnectionProvider with ChangeNotifier {
  final DioService _dioService;
  bool _isConnected = false;
  Timer? _timer;

  ConnectionProvider(this._dioService, ApiConfigService apiConfig) {
    // Inicializar la conexión al iniciar el proveedor
    startConnectionMonitoring(); //adicionar
  }

  bool get isConnected => _isConnected;

  Future<void> checkApiConnection() async {
    final isConnected = await _dioService.checkApiConnection();
    _isConnected = isConnected;
    notifyListeners(); // Esto es crucial para actualizar el estado
  }

  void startConnectionMonitoring({
    Duration interval = const Duration(seconds: 30),
  }) {
    checkApiConnection();
    _timer?.cancel();
    _timer = Timer.periodic(interval, (timer) async {
      await checkApiConnection();
    });
  }

  void updateConnectionState(bool isConnected) {
    _isConnected = isConnected;
    notifyListeners(); // Esto es crucial para actualizar el estado
  }

  Future<void> stopConnectionMonitoring() async {
    _timer?.cancel();
    return;
  }

  Future<void> checkInternetConnection() async {
    // Implementar lógica para verificar conexión a Internet
  }

  @override
  void dispose() {
    stopConnectionMonitoring();
    super.dispose();
  }
}
