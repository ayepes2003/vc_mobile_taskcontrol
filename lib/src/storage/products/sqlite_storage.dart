// lib/src/storage/sqlite_storage.dart
import 'dart:async';
// import 'package:flutter/services.dart';
import 'package:vc_taskcontrol/src/storage/data_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class SqliteStorage implements DataStorage {
  late Database _db;

  Future<Database> initDatabase() async {
    final directory = await getApplicationSupportDirectory();
    final path = join(directory.path, 'vc_taskcontrol.db');

    _db = await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE IF NOT EXISTS items (
            id INTEGER PRIMARY KEY,
            codigo TEXT NOT NULL,
            articulo TEXT NOT NULL,
            precioBase REAL NOT NULL,
            precioPublico REAL NOT NULL,
            cantidad INTEGER NOT NULL,
            total REAL NOT NULL
          )
        ''');
        db.execute('''
  CREATE TABLE IF NOT EXISTS products (
    id INTEGER PRIMARY KEY,
    productCode TEXT UNIQUE NOT NULL,
    sku TEXT,
    description TEXT NOT NULL,
    packagingUnit TEXT,
    salePrice REAL NOT NULL,
    publicPrice REAL NOT NULL,
    costPrice REAL NOT NULL,
    stock INTEGER NOT NULL
  )
''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < newVersion) {}
      },
    );

    return _db; // Devuelve la base de datos después de inicializarla
  }

  @override
  Future<void> loadData() async {
    await initDatabase();
    final List<Map<String, dynamic>> maps = await _db.query('items');
    _items = List<Map<String, dynamic>>.from(maps);
  }

  @override
  Future<void> saveData(List<Map<String, dynamic>> items) async {
    await initDatabase();
    await _db.delete('items');
    for (var item in items) {
      await _db.insert('items', item);
    }
  }

  @override
  Future<void> addItem(Map<String, dynamic> item) async {
    await initDatabase();
    await _db.insert('items', item);
  }

  @override
  Future<void> clearItems() async {
    await initDatabase();
    await _db.delete('items');
  }

  List<Map<String, dynamic>> _items = [];

  @override
  List<Map<String, dynamic>> get items => _items;

  @override
  Future<void> updateItem(Map<String, dynamic> item) async {
    await _db.update(
      'items',
      item,
      where: 'codigo = ?',
      whereArgs: [item['codigo']],
    );
  }
}
