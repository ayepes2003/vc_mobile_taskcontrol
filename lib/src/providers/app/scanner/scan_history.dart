import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/models/device/scan_item.dart';

class ScanHistoryProvider extends ChangeNotifier {
  final List<ScanItem> _items = [];

  List<ScanItem> get items => List.unmodifiable(_items);

  void addScan({
    required String code,
    required String deviceId,
    required DateTime timestamp,
    String? deviceModel,
    String? deviceAlias,
    bool sent = false,
  }) {
    _items.insert(
      0,
      ScanItem(
        code: code,
        dateTime: timestamp,
        deviceId: deviceId,
        deviceModel: deviceModel ?? '',
        deviceAlias: deviceAlias ?? '',
        sent: sent,
      ),
    );
    notifyListeners();
  }

  // Puedes añadir más métodos, por ejemplo para actualizar el estado sent:
  void setSent(int index, bool sent) {
    if (index >= 0 && index < _items.length) {
      _items[index] = _items[index].copyWith(
        sent: sent,
      ); // Asumiendo que tienes copyWith en ScanItem
      notifyListeners();
    }
  }

  // ...más métodos para limpiar, filtrar, sincronizar, etc.
}
