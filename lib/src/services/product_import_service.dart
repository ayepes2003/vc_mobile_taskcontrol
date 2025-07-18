// import 'dart:io';

// import 'package:flutter/services.dart' show rootBundle;
// import 'package:csv/csv.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:vc_taskcontrol/src/storage/product_storage.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';
// import '../providers/product_provider.dart';
// import '../storage/sqlite_product_storage.dart';

// class ProductImportService {
//   // final ProductProvider _productProvider;
//   final ProductStorage _storage;

//   ProductImportService(this._productProvider, this._storage);

//   Future<void> importProductsFromCSV(BuildContext context) async {
//     final pickedFile = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['csv'],
//     );

//     if (pickedFile != null) {
//       final file = File(pickedFile.files.first.path!);
//       final csvRows = await file.readAsString().then((csvData) {
//         return const CsvToListConverter().convert(csvData);
//       });

//       // Validación básica de estructura
//       if (csvRows.isEmpty || csvRows[0].length < 5) {
//         print('Archivo CSV vacío o estructura inválida');
//         return;
//       }

//       for (final row in csvRows.sublist(1)) {
//         if (row.length < 5) {
//           print('Fila con datos incompletos: ${row.join(',')}');
//           continue;
//         }

//         final product = {
//           'productCode': row[0],
//           'sku': row[1],
//           'description': row[2],
//           'packagingUnit': row[3],
//           'salePrice': double.tryParse(row[4]) ?? 0.0,
//         };

//         // Validación adicional (por ejemplo, verificar que el SKU no esté vacío)
//         if (product['sku']!.isEmpty) {
//           print('SKU vacío en fila: ${row.join(',')}');
//           continue;
//         }

//         try {
//           await _storage.addProduct(product);
//           print('Producto agregado: ${product['description']}');
//         } catch (e) {
//           print('Error al agregar producto: $e');
//         }
//       }
//     }
//   }
// }
