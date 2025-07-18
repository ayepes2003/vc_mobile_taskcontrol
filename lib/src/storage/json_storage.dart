import 'dart:convert';
import 'dart:io';
// import 'package:flutter/services.dart';
import 'package:vc_taskcontrol/src/storage/data_storage.dart';
import 'package:path_provider/path_provider.dart';

class JsonStorage implements DataStorage {
  List<Map<String, dynamic>> _items = [];

  @override
  List<Map<String, dynamic>> get items => _items;

  @override
  Future<void> loadData() async {
    try {
      final directory = await getApplicationSupportDirectory();
      final file = File('${directory.path}/data.json');

      if (!await file.exists()) {
        await file.create();
        await file.writeAsString(json.encode({'items': []}));
      }

      final String response = await file.readAsString();

      if (response.isEmpty) {
        await file.writeAsString(json.encode({'items': []}));
        _items = [];
      } else {
        final Map<String, dynamic> parsed = json.decode(response);
        if (parsed['items'] == null) {
          await file.writeAsString(json.encode({'items': []}));
          _items = [];
        } else {
          _items = List<Map<String, dynamic>>.from(parsed['items']);
        }
      }
    } catch (e) {
      print('Error cargando JSON: $e');
    }
  }

  @override
  Future<void> saveData(List<Map<String, dynamic>> items) async {
    try {
      final directory = await getApplicationSupportDirectory();
      final file = File('${directory.path}/data.json');

      if (!await file.exists()) {
        await file.create();
      }

      final String jsonString = json.encode({'items': items});
      await file.writeAsString(jsonString);
      print('Datos guardados en: ${file.path}');
    } catch (e) {
      print('Error guardando JSON: $e');
    }
  }

  @override
  Future<void> addItem(Map<String, dynamic> item) async {
    _items.add(item);
    await saveData(_items);
  }

  @override
  Future<void> clearItems() async {
    _items.clear();
    await saveData(_items);
  }

  @override
  Future<void> updateItem(Map<String, dynamic> item) {
    // TODO: implement updateItem
    throw UnimplementedError();
  }
}
