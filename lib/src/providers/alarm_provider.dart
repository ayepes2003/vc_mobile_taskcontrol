import 'package:flutter/material.dart';

class AlarmProvider with ChangeNotifier {
  List<Map<String, dynamic>> _alarms = [];

  List<Map<String, dynamic>> get alarms => _alarms;

  void addAlarm(Map<String, dynamic> alarm) {
    _alarms.add(alarm);
    notifyListeners();
  }
}
