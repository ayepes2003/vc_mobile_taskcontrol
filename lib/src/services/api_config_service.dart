import 'package:shared_preferences/shared_preferences.dart';
// import 'package:vc_taskcontrol/src/models/stepconfig.dart';
// import 'package:flutter/foundation.dart';

class ApiConfigService {
  static const String _apiUrlKey = 'api_url';

  Future<void> saveApiUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiUrlKey, url);
  }

  Future<String> getApiUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiUrlKey) ?? 'http://192.168.1.47:8000/api/v3';
  }
}
