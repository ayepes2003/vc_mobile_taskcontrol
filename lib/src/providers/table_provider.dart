// lib/src/providers/table_provider.dart
import 'package:flutter/material.dart';
import '../storage/data_storage.dart';

class TableProvider with ChangeNotifier {
  final DataStorage _storage;

  TableProvider(this._storage);

  List<Map<String, dynamic>> get items => _storage.items; // Usar _storage.items

  Future<void> loadData() async {
    await _storage.loadData();
    notifyListeners();
  }

  Future<void> addItem(Map<String, dynamic> item) async {
    await _storage.addItem(item);
    await _storage.loadData();
    notifyListeners();
  }

  // providers/table_provider.dart
  Future<void> updateItem(Map<String, dynamic> item) async {
    await _storage.updateItem(item);
    await _storage.loadData();
    notifyListeners();
  }

  Future<void> clearItems() async {
    await _storage.clearItems();

    await _storage.loadData();
    notifyListeners();
  }

  Map<String, dynamic>? getItemByCodeOrSku(String value) {
    try {
      print(value);
      return _storage.items.firstWhere(
        (item) => item['codigo'] == value || item['codigo'] == value,
      );
    } catch (e) {
      return null;
    }
  }
}
