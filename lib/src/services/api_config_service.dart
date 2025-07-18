// lib/src/services/api_config_service.dart
// import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiConfigService {
  static const String _apiUrlKey = 'api_url';

  Future<void> saveApiUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiUrlKey, url);
  }

  Future<String> getApiUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiUrlKey) ??
        'http://192.168.1.47:8000/api/v3'; // Valor por defecto
  }
}

        // 'http://agroonline_backend.test/api/v1'; // Valor por defecto