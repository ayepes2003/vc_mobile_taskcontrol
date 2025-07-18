import 'base_preferences.dart';

class GeneralPreferences extends BasePreferences {
  static bool _isWebSocket = false;
  static bool _isDarkMode = false;
  // 'http://192.168.1.47:8000/api/v3'
  static String _appName = 'Production Control Time';

  // static String _urlApiRest = '172.16.10.1';
  static String _endpoint = '/api/v3';
  static String _port = '8000';
  static String _urlWebSocket = '';
  static String _currentModule = '';

  // En GeneralPreferences.dart o similar

  // En GeneralPreferences.dart

  static String get apiProtocol =>
      BasePreferences.getString('apiProtocol') ?? 'http';

  static set apiProtocol(String value) =>
      BasePreferences.setString('apiProtocol', value);

  static String get apiBase =>
      BasePreferences.getString('apiBase') ?? '192.168.1.47';
  static set apiBase(String value) =>
      BasePreferences.setString('apiBase', value);

  static String get apiPort => BasePreferences.getString('apiPort') ?? '8000';
  static set apiPort(String value) =>
      BasePreferences.setString('apiPort', value);

  static String get apiEndpoint =>
      BasePreferences.getString('apiEndpoint') ?? '/api/v3';
  static set apiEndpoint(String value) =>
      BasePreferences.setString('apiEndpoint', value);

  static set isDarkMode(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    BasePreferences.setBool('isDarkMode', isDarkMode);
  }

  static bool get isDarkMode {
    return BasePreferences.getBool('isDarkMode') ?? _isDarkMode;
  }

  static bool get isWebSocket {
    return BasePreferences.getBool('isWebSocket') ?? _isWebSocket;
  }

  static set isWebSocket(bool isWebSocket) {
    _isWebSocket = isWebSocket;
    BasePreferences.setBool('isWebSocket', isWebSocket);
  }

  static String get urlWebSocket {
    return BasePreferences.getString('urlWebSocket') ?? _urlWebSocket;
  }

  static set urlWebSocket(String urlWebSocket) {
    _urlWebSocket = urlWebSocket;
    BasePreferences.setString('urlWebSocket', urlWebSocket);
  }

  // static String get urlApiRest {
  //   return BasePreferences.getString('urlApiRest') ?? _urlApiRest;
  // }

  // static set urlApiRest(String urlApiRest) {
  //   _urlApiRest = urlApiRest;
  //   BasePreferences.setString('urlApiRest', urlApiRest);
  // }

  static String get currentModule =>
      BasePreferences.getString('currentModule') ?? _currentModule;

  static set currentModule(String module) {
    _currentModule = module;
    BasePreferences.setString('currentModule', module);
  }

  static String get appName => BasePreferences.getString('appName') ?? _appName;
}
