import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/models/appsettings/tolerance_settings.dart';
import 'package:vc_taskcontrol/src/models/routescard/route_card.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:vc_taskcontrol/src/models/routescard/route_card_read.dart';
import 'package:vc_taskcontrol/src/services/dio_servide.dart';

class RouteCardProvider with ChangeNotifier {
  final DioService dioService;

  RouteCardProvider(this.dioService);

  List<RouteCard> _routes = [];
  bool _isLoading = false;
  String? lastError;

  List<RouteCard> get routes => List.unmodifiable(_routes);
  bool get isLoading => _isLoading;

  final List<RouteCardRead> _recentReads = [];
  List<RouteCardRead> get recentReads => List.unmodifiable(_recentReads);

  int tolerance = 0;
  int toleranceDifference = 1;

  Future<void> loadRoutesFromApi() async {
    try {
      print('Base URL actual de Dio: ${dioService.dio.options.baseUrl}');
      final response = await dioService.getRequest('/route-cards-active');
      final dataList =
          (response['data']['data'] as List)
              .map((item) => RouteCard.fromJson(item))
              .toList();
      _routes = dataList;
    } catch (e) {
      lastError = 'Error al cargar operators: $e';
      _routes = [];
    }
    notifyListeners();
  }

  Future<void> loadToleranceSettings() async {
    try {
      final response = await dioService.getRequest('/app-settings/tolerances');
      if (response['data'] != null &&
          response['data'] is List &&
          (response['data'] as List).isNotEmpty) {
        final tolJson = (response['data'] as List).first;
        tolerance = tolJson['tolerance'] ?? 0;
        toleranceDifference = tolJson['toleranceDifference'] ?? 1;
      } else {
        // Usa valores por defecto si no hay data
        tolerance = 0;
        toleranceDifference = 1;
      }
    } catch (e) {
      // En caso de error, usa valores por defecto
      tolerance = 0;
      toleranceDifference = 1;
    }
    notifyListeners();
  }

  String limpiar(String s) =>
      s.trim().replaceAll('\r', '').replaceAll('\n', '').toLowerCase();

  RouteCard? findByCodeProces(String code) {
    final buscado = limpiar(code);
    for (final rc in _routes) {
      if (limpiar(rc.codeProces) == buscado) {
        print(
          'MATCH ENCONTRADO: "${rc.codeProces} Cantidad de piezas: ${rc.initialQuantity}"',
        );
        return rc;
      }
    }
    print('NO ENCONTRADO tras limpiar');
    return null;
  }

  /// Añadir una nueva lectura (cuando el usuario escanea y confirma cantidad)
  void addRead(RouteCard card, int enteredQuantity) {
    print("${enteredQuantity} = ${card.codeProces}");
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

  List<RouteCardRead> get recentReadsLimited => _recentReads.take(8).toList();

  /// Limpiar las tarjetas de ruta cargadas
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
        return record.card.codeProces;
      case 'codePiece':
        return record.card.codePiece;
      case 'item':
        return record.card.item;
      case 'quantity':
        return record.card.quantity;
      case 'totalPiece':
        return record.card.totalPiece;
      case 'initialQuantity':
        return record.card.totalPiece;
      case 'enteredQuantity':
        return record.enteredQuantity.toString();
      case 'difference':
        print('DEBUG: difference handed to cell: ${record.difference}');
        return record.difference.toString();
      case 'status':
        return record.status;
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
