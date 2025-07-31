import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/models/routescard/route_card.dart';
import 'package:vc_taskcontrol/src/models/routescard/route_card_read.dart';
// import 'package:vc_taskcontrol/src/models/routescard/route_read_record.dart';
import 'package:vc_taskcontrol/src/services/dio_servide.dart';
import 'package:vc_taskcontrol/src/storage/routes/route_database.dart';

class RouteCardProvider with ChangeNotifier {
  final DioService dioService;
  final RouteDatabase routeDatabase = RouteDatabase();

  RouteCardProvider(this.dioService);

  // Estado y data

  List<RouteCard> _routes = [];
  List<RouteCardRead> _recentReads = [];
  bool _isLoading = false;
  String? lastError;

  // Accesores para UI
  List<RouteCard> get routes => List.unmodifiable(_routes);
  List<RouteCardRead> get recentReads => List.unmodifiable(_recentReads);
  List<RouteCardRead> get recentReadsLimited => _recentReads.take(8).toList();
  bool get isLoading => _isLoading;

  // Configuración (puedes adaptar o sacar si no lo usas)
  int tolerance = 0;
  int toleranceDifference = 1;

  /// Carga rutas desde API y guarda/actualiza SQLite
  Future<void> loadRoutesFromApi() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await dioService.getRequest('/route-cards-active');
      final dataList =
          (response['data']['data'] as List)
              .map((item) => RouteCard.fromJson(item))
              .toList();

      // Guardar o actualizar en DB local
      for (var route in dataList) {
        final localRoute = RouteCard(
          id: route.id,
          serverId: route.serverId,
          codeProces: route.codeProces,
          routeNum: route.routeNum,
          internalCode: route.internalCode,
          projectName: route.projectName,
          projectCode: route.projectCode,
          codeDispatch: route.codeDispatch,
          codeSalesErp: route.codeSalesErp,
          itemCode: route.itemCode,
          descriptionMaterial: route.descriptionMaterial,
          pieceType: route.pieceType,
          codePiece: route.codePiece,
          pieceNum: route.pieceNum,
          totalPiece: route.totalPiece,
          labelPiece: route.labelPiece,
          quantity: route.quantity,
          grain: route.grain,
          initialQuantity: route.initialQuantity,
          totalPieceBase: route.totalPieceBase,
          sectionId: route.sectionId,
          sectionName: route.sectionName,
          statusName: route.statusName,
          statusColor: route.statusColor,
          statusDescription: route.statusDescription,
          deviceId: 'tabletDev',
          statusId: 2,
          syncAttempts: 0,
          captureDate: DateTime.now().toIso8601String(),
          updateTimestamp: route.statusDescription,
        );

        await routeDatabase.insertOrUpdateRouteCard(localRoute);
      }

      _routes = dataList;
      lastError = null;
    } catch (e) {
      lastError = 'Error al cargar rutas: $e';
      print(e);
      _routes = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Carga rutas desde SQLite
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

  /// Guarda una ruta en SQLite manualmente y recarga rutas locales
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
    // if (enteredQuantity > initialQuantity) {
    //   throw Exception(
    //     'Entered quantity exceeds initial quantity for card ${card.codeProces}.',
    //   );
    // }
    final int difference =
        initialQuantity - (totalRegistered + enteredQuantity);

    // final int difference =
    //     (int.tryParse(card.totalPiece ?? '0') ?? 0) - enteredQuantity;

    await routeDatabase.insertRead({
      'route_card_id': routeCardId,
      'code_proces': card.codeProces,
      'entered_quantity': enteredQuantity,
      'difference': difference,
      'read_at': DateTime.now().toIso8601String(),
      'device_id': 'tabletDev',
      'status_id': 1,
      'sync_attempts': 0,
    });

    await loadRecentReads();
  }

  /// Agrega lectura sólo en memoria (no persistente)
  void addRead(RouteCard card, int enteredQuantity) {
    _recentReads.insert(
      0,
      RouteCardRead(
        card: card,
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
    // {
    //   'key': 'item',
    //   'titulo': 'Item',
    //   'ancho': 200.0,
    //   'align': TextAlign.left,
    //   'colorFondo': Colors.white,
    //   'colorTexto': Colors.black,
    //   'visible': false,
    //   'tooltip': 'Referente a producto/mueble',
    //   'icono': Icons.chair_outlined,
    // },
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
    // {
    //   'key': 'difference',
    //   'titulo': 'Faltante',
    //   'ancho': 50.0,
    //   'align': TextAlign.right,
    //   'colorFondo': Colors.white,
    //   'colorTexto': Colors.black,
    //   'visible': true,
    //   'tooltip': 'Diferencia entre estimada y digitada',
    //   'icono': Icons.error_outline,
    // },
    // {
    //   'key': 'status',
    //   'titulo': 'Estado',
    //   'ancho': 40.0,
    //   'align': TextAlign.center,
    //   'colorFondo': Colors.white,
    //   'colorTexto': Colors.black,
    //   'visible': true,
    //   'tooltip': 'Estado de la lectura',
    //   'icono': Icons.info_outline,
    // },
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


// {'titulo':'Grano','key':'grain','...'},
// {'titulo': 'Proyecto',   'key': 'projectName', ...},
  // {'titulo': 'Despacho',   'key': 'codeDispacht', ...},
  // {'titulo': 'ERP',        'key': 'codeSalesErp', ...},
  // {'titulo': 'Descripción Material', 'key': 'descriptionMaterial', ...},
  // {'titulo': 'Tipo Pieza', 'key': 'pieceType', ...},
  // {'titulo': 'Núm. Pieza', 'key': 'numPiece', ...},
  // {'titulo': 'Largo 1',    'key': 'length1', ...},
  // {'titulo': 'Ancho 1',    'key': 'width1', ...},
  // {'titulo': 'Notas A',    'key': 'notesA', ...},
  // {'titulo': 'Largo 2',    'key': 'length2', ...},
  // {'titulo': 'Ancho 2',    'key': 'width2', ...},
  // {'titulo': 'Notas B',    'key': 'notesB', ...},
  // {'titulo': '# Piezas Totales',   'key': 'totalPiece', ...},
  // {'titulo': '# Piezas Etiqueta','key': 'labelPiece', ...},

   /// Cargar las tarjetas de ruta desde un archivo CSV local
// Future<void> loadRoutesFromCSV() async {
//   _isLoading = true;
//   notifyListeners();

//   try {
//     final rawData = await rootBundle.loadString('data/card_route_trans.csv');
//     // print(rawData.substring(0, 500));
//     final rowsAsList = const CsvToListConverter(
//       fieldDelimiter: ';',
//       eol: '\r\n',
//     ).convert(rawData);

//     if (rowsAsList.isEmpty) {
//       _routes = [];
//       _isLoading = false;
//       print('Cantidad de tarjetas de ruta cargadas: en vacias ');
//       notifyListeners();
//       return;
//     }

//     final headers = rowsAsList.first;

//     _routes =
//         rowsAsList.skip(1).map((row) {
//           // 1. Convierte los valores a String y garantiza misma longitud que header
//           final fixedRow = List<String>.from(
//             row.map((e) => e?.toString() ?? ''),
//           );
//           while (fixedRow.length < headers.length) {
//             fixedRow.add('');
//           }
//           // 2. En caso de exceso de columnas, ignora las extras
//           final rowData = fixedRow.take(headers.length);

//           // 3. Crea el mapa y el modelo normalmente
//           final data = Map<String, dynamic>.fromIterables(
//             headers.map((e) => e.toString()),
//             rowData,
//           );
//           return RouteCard.fromJson(data);
//         }).toList();
//   } catch (e) {
//     print('catch: $e');
//     _routes = [];
//   }

//   _isLoading = false;
//   print('Cantidad de tarjetas de ruta cargadas: ${_routes.length}');
//   notifyListeners();
// }

