import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vc_taskcontrol/src/models/routescard/route_card.dart';
import 'package:vc_taskcontrol/src/models/routescard/route_card_read.dart';
import 'package:vc_taskcontrol/src/models/routescard/route_initial_data.dart';

class RouteDatabase {
  static final RouteDatabase _instance = RouteDatabase._internal();
  factory RouteDatabase() => _instance;
  static Database? _database;

  RouteDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, 'route_cards.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      // onUpgrade: _onUpgrade, // para migraciones futuras si se necesita
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    // Tabla route_cards para rutas completas
    //server_id Id del backEnd
    // id INTEGER PRIMARY KEY,

    await db.execute('''
      CREATE TABLE IF NOT EXISTS route_cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        server_id INTEGER,
        code_proces TEXT NOT NULL UNIQUE,
        route_num TEXT,
        internal_code TEXT,
        project_name TEXT,
        project_code TEXT,
        code_dispatch TEXT,
        code_sales_erp TEXT,
        item_code TEXT,
        description_material TEXT,
        piece_type TEXT,
        code_piece TEXT,
        piece_num TEXT,
        total_piece TEXT,
        label_piece TEXT,
        quantity TEXT,
        grain TEXT,
        initial_quantity TEXT,
        total_piece_base TEXT,
        section_id TEXT,
        section_name TEXT,
        status_name TEXT,
        status_color TEXT,
        status_description TEXT,
        device_id TEXT,
        status_id INTEGER,
        sync_attempts INTEGER,
        capture_date TEXT,
        update_timestamp TEXT
        )
    ''');
    // Create Tablet Initial Route Data Table
    await db.execute('''
        CREATE TABLE route_initial_data (
          id INTEGER PRIMARY KEY,
          server_id INTEGER,
          code_proces TEXT NOT NULL,
          production_baseline_id INTEGER NOT NULL,
          project_production_id INTEGER NOT NULL,
          section_id INTEGER NOT NULL,
          route_num TEXT NOT NULL,
          initial_quantity INTEGER NOT NULL,
          status_id INTEGER NOT NULL,
          section_name TEXT,
          pp_id INTEGER,
          pp_project_id INTEGER,
          pp_status_id INTEGER,
          project_name TEXT,
          project_code TEXT,
          code_dispatch TEXT,
          code_sales_erp TEXT
        )
      ''');

    await db.execute('''
      DROP TABLE IF EXISTS route_card_reads;
    ''');

    // Tabla route_card_reads para registros de lectura/scan de rutas
    await db.execute('''
      CREATE TABLE IF NOT EXISTS route_card_reads (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        route_card_id INTEGER,
        code_proces TEXT,
        entered_quantity INTEGER DEFAULT 0,
        difference INTEGER DEFAULT 0,
        accum_diff INTEGER DEFAULT 0,
        read_at TEXT,
        supervisor TEXT,
        selected_hour_range TEXT NULL,
        section TEXT NULL,
        subsection TEXT NULL,
        operator TEXT NULL,
        supervisory_id INTEGER NULL,
        section_id INTEGER NULL,
        subsection_id INTEGER NULL,
        operator_id INTEGER NULL,
        device_id TEXT,
        status_id INTEGER,
        sync_attempts INTEGER,
        FOREIGN KEY (route_card_id) REFERENCES route_cards(id)
      )
    ''');
  }

  // Insertar o actualizar RouteCard
  Future<void> insertOrUpdateRouteCard(RouteCard card) async {
    final dbPath = await getDatabasesPath();
    // print('Database path: $dbPath/route_cards.db');

    final db = await database;
    await db.insert(
      'route_cards',
      card.toMap(forInsert: true),
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Buscar RouteCard por código de proceso
  Future<RouteCard?> getRouteCardByCodeProces(String code) async {
    final db = await database;
    final maps = await db.query(
      'route_cards',
      where: 'code_proces = ?',
      whereArgs: [code],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return RouteCard.fromMap(maps.first);
    }
    return null;
  }

  // Obtener todas las rutas
  Future<List<RouteCard>> getAllRouteCards() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('route_cards');
    return maps.map((map) => RouteCard.fromMap(map)).toList();
  }

  Future<List<RouteInitialData>> getAllRouteInitialCards() async {
    final db = await database; // El método que abre tu conexión SQLite
    final List<Map<String, dynamic>> maps = await db.query(
      'route_initial_data',
    );
    return maps.map((map) => RouteInitialData.fromMap(map)).toList();
  }

  // Función para buscar un registro según la clave única compuesta
  Future<RouteInitialData?> getRouteInitialCardByUniqueKey(
    DatabaseExecutor db,
    RouteInitialData route,
  ) async {
    final maps = await db.query(
      'route_initial_data',
      where:
          'code_proces = ? AND production_baseline_id = ? AND project_production_id = ? AND section_id = ? AND route_num = ?',
      whereArgs: [
        route.codeProces,
        route.productionBaselineId,
        route.projectProductionId,
        route.sectionId,
        route.routeNum,
      ],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return RouteInitialData.fromMap(maps.first);
    }
    return null;
  }

  // Función para insertar o actualizar un registro basado en llave única compuesta
  Future<void> insertOrUpdateRouteInitialData(RouteInitialData route) async {
    final db = await database;
    await db.transaction((txn) async {
      final existing = await getRouteInitialCardByUniqueKey(txn, route);
      if (existing == null) {
        // Insertamos sin 'server_id' si queremos que SQLite lo maneje como PK local autoincremental
        await txn.insert(
          'route_initial_data',
          route.toMap(forInsert: false),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else {
        // Actualizamos los campos existentes
        await txn.update(
          'route_initial_data',
          route.toMap(),
          where:
              'code_proces = ?  AND production_baseline_id = ? AND project_production_id = ? AND section_id = ? AND route_num = ?',
          whereArgs: [
            route.codeProces,
            route.productionBaselineId,
            route.projectProductionId,
            route.sectionId,
            route.routeNum,
          ],
        );
      }
    });
  }

  // Función para sincronizar toda la lista en SQLite (usa la inserción o actualización)
  Future<void> syncRouteInitialData(List<RouteInitialData> dataList) async {
    final db = await database;
    await db.transaction((txn) async {
      for (var route in dataList) {
        final existing = await getRouteInitialCardByUniqueKey(txn, route);
        if (existing == null) {
          await txn.insert('route_initial_data', route.toMap(forInsert: true));
        } else {
          await txn.update(
            'route_initial_data',
            route.toMap(),
            where:
                'code_proces = ? AND production_baseline_id = ? AND project_production_id = ? AND section_id = ? AND route_num = ?',
            whereArgs: [
              route.codeProces,
              route.productionBaselineId,
              route.projectProductionId,
              route.sectionId,
              route.routeNum,
            ],
          );
        }
      }
    });
  }

  Future<RouteInitialData?> getRouteInitialCardByCodeProces(String code) async {
    final db = await database;
    final maps = await db.query(
      'route_initial_data',
      where: 'code_proces = ?',
      whereArgs: [code],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return RouteInitialData.fromMap(maps.first);
    }
    return null;
  }

  // Obtener suma total de cantidades registradas en lecturas para un código de proceso
  Future<int> getTotalRegisteredQuantity(String codeProces) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT SUM(entered_quantity) as total
      FROM route_card_reads
      WHERE code_proces = ?
      ''',
      [codeProces],
    );
    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as int;
    }
    return 0;
  }

  // Insertar nueva lectura en route_card_reads
  Future<void> insertRead(Map<String, dynamic> readData) async {
    final db = await database;
    await db.insert(
      'route_card_reads',
      readData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener ID de ruta local por código de proceso
  Future<int?> getRouteCardIdByCodeProces(String codeProces) async {
    final db = await database;
    final maps = await db.query(
      'route_cards',
      columns: ['id'],
      where: 'code_proces = ?',
      whereArgs: [codeProces],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return maps.first['id'] as int;
    }
    return null;
  }

  // Obtener lecturas recientes con JOIN para obtener ruta completa (con límite)
  Future<List<RouteCardRead>> getRecentReads({int limit = 50}) async {
    final db = await database;
    final results = await db.rawQuery(
      '''
      SELECT r.id as read_id,
             r.route_card_id,
             r.entered_quantity,
             r.difference,
             r.read_at,
             r.device_id as read_device_id,
             r.status_id as read_status_id,
             r.sync_attempts as read_sync_attempts,
             c.*
      FROM route_card_reads r
      LEFT JOIN route_cards c ON r.route_card_id = c.id
      ORDER BY r.read_at DESC
      LIMIT ?
    ''',
      [limit],
    );

    return results.map((row) {
      try {
        final card = RouteCard.fromMap(row);
        return RouteCardRead(
          card: card,
          enteredQuantity: row['entered_quantity'] as int,
          difference: row['difference'] as int?,
          readAt: DateTime.tryParse(row['read_at'] as String) ?? DateTime.now(),
          status: row['read_status_id']?.toString(),
          deviceId: row['read_device_id']?.toString(),
          syncAttempts: row['read_sync_attempts'] as int?,
        );
      } catch (e) {
        // En caso de error, devolver lectura sin ruta pero con datos básicos
        return RouteCardRead(
          card: null,
          enteredQuantity: row['entered_quantity'] as int,
          difference: row['difference'] as int?,
          readAt: DateTime.tryParse(row['read_at'] as String) ?? DateTime.now(),
        );
      }
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAllReadsAsMap() async {
    final db = await database;
    return await db.query('route_card_reads'); // devuelve todos los registros
  }

  // Borrar todas las lecturas (opcional)
  Future<void> clearAllReads() async {
    final db = await database;
    await db.delete('route_card_reads');
    await db.delete('route_initial_data');
  }

  Future<void> clearAllData() async {
    final db = await database;
    // await db.delete('route_cards');
    await db.delete('route_card_reads');
    await db.delete('route_initial_data');
  }

  // Cerrar base de datos
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
