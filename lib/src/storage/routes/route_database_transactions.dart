import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:vc_taskcontrol/src/models/routescard/route_card.dart';
import 'package:vc_taskcontrol/src/storage/routes/route_database.dart';

extension RouteDatabaseOperations on RouteDatabase {
  // Insertar o reemplazar ruta
  Future<void> insertOrUpdateRouteApiCard(RouteCard card) async {
    final db = await database;
    await db.insert(
      'route_api_cards',
      card.toJson(), // o toMap, según tengas definido el método
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Insertar lectura
  Future<int> insertRead(Map<String, dynamic> read) async {
    final db = await database;
    return await db.insert('route_card_reads', read);
  }

  // Obtener suma de cantidades ya registradas por code_proces que estén PENDING o SENT
  Future<int> getTotalRegisteredQuantity(String codeProces) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT SUM(entered_quantity) as total 
      FROM route_card_reads 
      WHERE code_proces = ? AND status_id IN (1, 2)
    ''',
      [codeProces],
    );
    if (result.isNotEmpty) {
      return result.first['total'] as int? ?? 0;
    }
    return 0;
  }

  // Actualizar estado de lectura
  Future<int> updateReadStatus(int readId, int statusId) async {
    final db = await database;
    return await db.update(
      'route_card_reads',
      {'status_id': statusId},
      where: 'id = ?',
      whereArgs: [readId],
    );
  }

  // Borrar lecturas sincronizadas si ruta actualizada
  Future<int> deleteSyncedReadsForRoute(int routeCardId) async {
    final db = await database;
    return await db.delete(
      'route_card_reads',
      where: 'route_card_id = ? AND status_id = ?',
      whereArgs: [routeCardId, 2],
    );
  }

  // Obtener route_card_id por code_proces
  Future<int?> getRouteCardIdByCodeProces(String codeProces) async {
    final db = await database;
    final result = await db.query(
      'route_cards',
      columns: ['id'],
      where: 'code_proces = ?',
      whereArgs: [codeProces],
      limit: 1,
    );
    if (result.isNotEmpty) return result.first['id'] as int;
    return null;
  }
}

/*
  Future<int> insertOrUpdateRoute(Map<String, dynamic> route) async {
    final db = await database;
    return await db.insert(
      'route_cards',
      route,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
 */
