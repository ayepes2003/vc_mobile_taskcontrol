import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/models/routescard/route_card.dart';
import 'package:vc_taskcontrol/src/models/routescard/route_card_read.dart';
import 'package:vc_taskcontrol/src/models/routescard/route_initial_data.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/route_data_provider.dart';
// import 'package:vc_taskcontrol/src/models/routescard/route_read_record.dart';
import 'package:vc_taskcontrol/src/services/dio_servide.dart';
import 'package:vc_taskcontrol/src/storage/preferences/app_preferences.dart';
import 'package:vc_taskcontrol/src/storage/routes/route_database.dart';

class RouteCardProvider with ChangeNotifier {
  final DioService dioService;
  RouteDataProvider routeDataProvider;
  final RouteDatabase routeDatabase = RouteDatabase();

  // Constructor recibe instancia única de dioService y routeDataProvider
  RouteCardProvider(this.dioService, this.routeDataProvider);

  // Método para actualizar sólo el routeDataProvider sin cambiar dioService ni recrear provider
  void updateRouteDataProvider(RouteDataProvider newProvider) {
    routeDataProvider = newProvider;
    notifyListeners();
  }

  // Estado y data
  List<RouteCard> _routes = [];
  List<RouteInitialData> _routesInitial = [];
  List<RouteCardRead> _recentReads = [];
  bool _isLoading = false;
  String? lastError;

  // Accesores para UI
  List<RouteCard> get routes => List.unmodifiable(_routes);
  List<RouteInitialData> get routesInitial => List.unmodifiable(_routesInitial);
  List<RouteCardRead> get recentReads => List.unmodifiable(_recentReads);
  List<RouteCardRead> get recentReadsLimited => _recentReads.take(8).toList();
  bool get isLoading => _isLoading;

  // Configuración (puedes adaptar o sacar si no lo usas)
  int tolerance = 0;
  int toleranceDifference = 1;

  Future<void> loadAndSyncInitialDataFromApi({
    required String sectionName,
  }) async {
    _isLoading = true;
    notifyListeners();
    final sectionName = AppPreferences.getSection();
    try {
      final response = await dioService.getRequest(
        '/initial-data?section_name=$sectionName',
      );
      final dataList =
          (response['data']['data'] as List)
              .map((item) => RouteInitialData.fromJson(item))
              .toList();

      // 1. Obtener lista completa de codeProces locales de una vez:
      final localRoutes = await routeDatabase.getAllRouteInitialCards();
      final localCodeProcesSet = localRoutes.map((r) => r.codeProces).toSet();

      // 2. Recorrer lista del backend y decidir insertar sólo los nuevos
      for (var route in dataList) {
        if (!localCodeProcesSet.contains(route.codeProces)) {
          await routeDatabase.insertOrUpdateRouteInitialData(route);
        } else {
          // Opcional: aquí también podrías comparar statusId para actualizar si cambió
          // Por ahora omitimos para optimizar tiempo
        }
      }

      // await routeDatabase.syncRouteInitialData(dataList);
      _routesInitial = dataList;
      lastError = null;
    } catch (e) {
      lastError = 'Error al cargar rutas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadInitialRoutesFromApi({String? sectionName}) async {
    _isLoading = true;
    notifyListeners();
    final sectionName = AppPreferences.getSection();
    try {
      final response = await dioService.getRequest(
        '/initial-data?section_name=$sectionName',
      );
      final dataList =
          (response['data']['data'] as List)
              .map((item) => RouteInitialData.fromJson(item))
              .toList();
      // 1. Obtener lista completa de codeProces locales de una vez:
      final localRoutes = await routeDatabase.getAllRouteInitialCards();
      final localCodeProcesSet = localRoutes.map((r) => r.codeProces).toSet();

      // 2. Recorrer lista del backend y decidir insertar sólo los nuevos
      for (var route in dataList) {
        if (!localCodeProcesSet.contains(route.codeProces)) {
          await routeDatabase.insertOrUpdateRouteInitialData(route);
        } else {
          // Opcional: aquí también podrías comparar statusId para actualizar si cambió
          // Por ahora omitimos para optimizar tiempo
        }
      }
      _routesInitial = dataList;
      lastError = null;
    } catch (e) {
      lastError = 'Error al cargar rutas: $e';
      // print(e);
      _routesInitial = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadRoutesFromApi({String? sectionName}) async {
    _isLoading = true;
    notifyListeners();
    final sectionName = AppPreferences.getSection();
    try {
      final response = await dioService.getRequest(
        '/route-cards-active?section_name=$sectionName',
      );
      final dataList =
          (response['data']['data'] as List)
              .map((item) => RouteCard.fromJson(item))
              .toList();

      // 1. Obtener lista completa de codeProces locales de una vez:
      final localRoutes = await routeDatabase.getAllRouteCards();
      final localCodeProcesSet = localRoutes.map((r) => r.codeProces).toSet();

      // 2. Recorrer lista del backend y decidir insertar sólo los nuevos
      for (var route in dataList) {
        if (!localCodeProcesSet.contains(route.codeProces)) {
          await routeDatabase.insertOrUpdateRouteCard(route);
        } else {
          // Opcional: aquí también podrías comparar statusId para actualizar si cambió
          // Por ahora omitimos para optimizar tiempo
        }
      }

      _routes = dataList;
      lastError = null;
    } catch (e) {
      lastError = 'Error al cargar rutas: $e';
      // print(e);
      _routes = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String> exportReadsAsJson() async {
    final readsAsMap = await routeDatabase.getAllReadsAsMap();
    return jsonEncode(readsAsMap);
  }

  Future<void> loadRoutesFromLocal() async {
    try {
      final localRoutes = await routeDatabase.getAllRouteCards();
      _routes = localRoutes;
      notifyListeners();
    } catch (e) {
      print('Error loading routes from local DB: $e');
    }
  }

  /// Carga lecturas recientes desde SQLite
  Future<void> loadRecentReads() async {
    try {
      final recentReads = await routeDatabase.getRecentReads();
      _recentReads = recentReads;
      notifyListeners();
    } catch (e) {
      print('Error loading recent reads from local DB: $e');
    }
  }

  /// Obtiene suma total registrada para un código de proceso
  Future<int> getTotalRegisteredQuantity(String codeProces) async {
    return await routeDatabase.getTotalRegisteredQuantity(codeProces);
  }

  // Guarda una ruta en SQLite manualmente y recarga rutas locales
  Future<void> saveRouteCard(RouteCard card) async {
    await routeDatabase.insertOrUpdateRouteCard(card);
    await loadRoutesFromLocal();
  }

  /// Agrega una lectura local (guardado en SQLite) y recarga lecturas
  Future<void> addReadLocal(RouteCard card, int enteredQuantity) async {
    final routeCardId = await routeDatabase.getRouteCardIdByCodeProces(
      card.codeProces,
    );

    if (routeCardId == null) {
      throw Exception(
        'RouteCard not found in local database for saving reading.',
      );
    }

    final int totalRegistered = await routeDatabase.getTotalRegisteredQuantity(
      card.codeProces,
    );

    final int initialQuantity = int.tryParse(card.initialQuantity) ?? 0;

    final int difference =
        initialQuantity - (totalRegistered + enteredQuantity);

    final String? section = routeDataProvider.section;

    print(
      'Valores a insertar: supervisor=${routeDataProvider.supervisor}, hour=${routeDataProvider.selectedHourRange}, subsection=${routeDataProvider.subsection}, operator=${routeDataProvider.operatorName}',
    );

    await routeDatabase.insertRead({
      'route_card_id': routeCardId,
      'code_proces': card.codeProces,
      'entered_quantity': enteredQuantity,
      'difference': difference,
      'read_at': DateTime.now().toIso8601String(),
      'device_id': 'tabletDev',
      'status_id': 1,
      'sync_attempts': 0,

      // Puedes incluir aquí campos nuevos de contextos si los quieres guardar directamente
      'supervisor': routeDataProvider.supervisor,
      'selected_hour_range': routeDataProvider.selectedHourRange,
      'section': routeDataProvider.section,
      'subsection': routeDataProvider.subsection,
      'operator': routeDataProvider.operatorName,
      'supervisory_id': routeDataProvider.selectedSupervisorId,
      'section_id': routeDataProvider.selectedSection?.id,
      // 'subsection_id': routeDataProvider.selectedSubsection?.id,
      // 'operator_id': routeDataProvider.selectedOperator?.id,

      // Aquí si usas accumDiff, calcula y pásalo igual (deja null por ahora si no tienes lógica)
      'accum_diff': null,
    });

    await loadRecentReads();
  }

  /// Agrega lectura sólo en memoria (no persistente)
  void addRead(RouteCard card, int enteredQuantity) {
    _recentReads.insert(
      0,
      RouteCardRead(
        card: card,
        section: card.sectionName,
        enteredQuantity: enteredQuantity,
        readAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  /// Borra todas las lecturas locales
  Future<void> clearAllReads() async {
    final db = await routeDatabase.database;
    await db.delete('route_card_reads');
    _recentReads = [];
    notifyListeners();
  }

  /// Método util para limpiar strings
  String limpiar(String s) =>
      s.trim().replaceAll('\r', '').replaceAll('\n', '').toLowerCase();

  /// Buscar ruta en memoria por código de proceso
  RouteCard? findByCodeProces(String code) {
    final buscado = limpiar(code);
    for (final rc in _routes) {
      if (limpiar(rc.codeProces) == buscado) {
        print(
          'Match found: "${rc.codeProces} Quantity: ${rc.initialQuantity}"',
        );
        return rc;
      }
    }
    print('No match found after cleaning');
    return null;
  }

  /// Última lectura registrada (si existe)
  RouteCardRead? get lastRead {
    if (_recentReads.isEmpty) return null;
    return _recentReads.last;
  }

  /// Tarjeta relacionada con la última lectura registrada
  RouteCard? get lastReadCard {
    final last = lastRead;
    if (last == null) return null;
    return last.card;
  }

  /// Cantidad estimada (initialQuantity) de la última tarjeta leída
  int get estimatedQuantity {
    final card = lastReadCard;
    if (card == null) return 0;
    // Convierte string a int con seguridad
    return int.tryParse(card.initialQuantity) ?? 0;
  }

  /// Cantidad real leída en la última lectura
  int get realQuantity {
    final last = lastRead;
    if (last == null) return 0;
    return last.enteredQuantity;
  }

  /// Diferencia entre cantidad estimada y real, para la última tarjeta leída
  int get difference {
    final estimated = estimatedQuantity;
    final realAccum = realQuantityAccumulated;

    int diff = estimated - realAccum;
    return diff < 0 ? 0 : diff; // evitar negativos, opcional
  }

  int get realQuantityAccumulated {
    final card = lastReadCard;
    if (card == null) return 0;

    final code = card.codeProces;
    if (code == null) return 0;

    // Sumar todas las cantidades digitadas para esta tarjeta (codeProces)
    final sum = _recentReads
        .where((read) => read.card?.codeProces == code)
        .fold(0, (prev, read) => prev + read.enteredQuantity);

    return sum;
  }

  /// Limpiar rutas cargadas en memoria
  void clearRoutes() {
    _routes = [];
    notifyListeners();
  }

  final columnsTablet = [
    {
      'key': 'codeProces',
      'titulo': 'TarjetaNo',
      'ancho': 80.0,
      'align': TextAlign.left,
      'colorFondo': Colors.white, // reemplaza con tu color corporativo
      'colorTexto': Colors.black,
      'visible': true,
      'tooltip': 'Número único de la tarjeta de ruta',
      'icono': Icons.confirmation_number_outlined,
    },
    {
      'key': 'codePiece',
      'titulo': 'Pieza',
      'ancho': 80.0,
      'align': TextAlign.left,
      'colorFondo': Colors.white,
      'colorTexto': Colors.black,
      'visible': true,
      'tooltip': 'Código de la pieza',
      'icono': Icons.precision_manufacturing_outlined,
    },
    // ... otras columnas ...
    {
      'key': 'totalPiece',
      'titulo': 'Cant Inicial',
      'ancho': 50.0,
      'align': TextAlign.right,
      'colorFondo': Colors.white,
      'colorTexto': Colors.black,
      'visible': true,
      'tooltip': 'Cantidad estimada esperada',
      'icono': Icons.numbers_outlined,
    },
    {
      'key': 'quantity',
      'titulo': 'Cant Inicial',
      'ancho': 60.0,
      'align': TextAlign.right,
      'colorFondo': Colors.white,
      'colorTexto': Colors.black,
      'visible': false,
      'tooltip': 'Cantidad estimada esperada',
      'icono': Icons.numbers_outlined,
    },
    {
      'key': 'enteredQuantity',
      'titulo': 'Digitada',
      'ancho': 50.0,
      'align': TextAlign.right,
      'colorFondo': Colors.white,
      'colorTexto': Colors.black,
      'visible': true,
      'tooltip': 'Cantidad ingresada al leer',
      'icono': Icons.edit_outlined,
    },
    // ... otras columnas ...
  ];

  List<Map<String, dynamic>> get columnsTabletVisibles {
    return columnsTablet.where((col) => col['visible'] as bool).toList();
  }

  String getCellValue(RouteCardRead record, String key) {
    switch (key) {
      case 'codeProces':
        return record.card?.codeProces ?? '';
      case 'codePiece':
        return record.card?.codePiece ?? '';
      case 'item':
        return record.card?.itemCode ?? '';
      case 'quantity':
        return record.card?.quantity ?? '';
      case 'totalPiece':
        return record.card?.totalPiece ?? '';
      case 'initialQuantity':
        return record.card?.initialQuantity ?? '';
      case 'enteredQuantity':
        return record.enteredQuantity.toString();
      case 'difference':
        print('DEBUG: difference handed to cell: ${record.difference}');
        return record.difference.toString();
      case 'status':
        return record.status ?? 'N/A';
      default:
        return '';
    }
  }
}
