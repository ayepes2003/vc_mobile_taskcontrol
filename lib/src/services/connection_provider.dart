import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/services/api_config_service.dart';
import 'package:vc_taskcontrol/src/services/dio_servide.dart';

class ConnectionProvider with ChangeNotifier {
  final DioService _dioService;
  bool _isConnected = false;
  Timer? _periodicTimer;
  Timer? _graceTimer;

  // Duración de la "ventana de gracia" para tolerar microcortes
  final Duration graceDuration = const Duration(seconds: 15);

  ConnectionProvider(this._dioService, ApiConfigService apiConfig) {
    startConnectionMonitoring();
  }

  bool get isConnected => _isConnected;

  Future<void> checkApiConnection() async {
    final bool currentState = await _dioService.checkApiConnection();

    if (currentState) {
      // Si recupera conexión durante la ventana de gracia, cancela el timer y reestablece el estado a conectado
      _graceTimer?.cancel();
      if (!_isConnected) {
        _isConnected = true;
        notifyListeners();
      }
    } else {
      // Si se detecta desconexión, inicia la ventana de gracia solo si no hay otro timer activo
      if (_graceTimer == null || !_graceTimer!.isActive) {
        _graceTimer = Timer(graceDuration, () async {
          // Al expirar la ventana de gracia, verifica de nuevo antes de marcar como desconectado
          final stillDisconnected = !await _dioService.checkApiConnection();
          if (stillDisconnected && _isConnected) {
            _isConnected = false;
            notifyListeners();
          }
        });
      }
    }
  }

  void startConnectionMonitoring({
    Duration interval = const Duration(seconds: 45),
  }) {
    checkApiConnection();
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(interval, (timer) async {
      await checkApiConnection();
    });
  }

  void updateConnectionState(bool isConnected) {
    _graceTimer?.cancel();
    if (_isConnected != isConnected) {
      _isConnected = isConnected;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _periodicTimer?.cancel();
    _graceTimer?.cancel();
    super.dispose();
  }
}
