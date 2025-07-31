import 'package:vc_taskcontrol/src/storage/products/product_storage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqliteProductStorage implements ProductStorage {
  final Database _db;

  SqliteProductStorage(this._db) {}

  @override
  Future<List<Map<String, dynamic>>> loadProducts() async {
    final maps = await _db.query('products');
    return maps;
  }

  @override
  Future<void> addProduct(Map<String, dynamic> product) async {
    await _db.insert('products', product);
  }

  @override
  Future<void> updateProduct(Map<String, dynamic> product) async {
    await _db.update(
      'products',
      product,
      where: 'sku = ?',
      whereArgs: [product['sku']],
    );
  }

  @override
  Future<void> deleteProduct(String sku) async {
    await _db.delete('products', where: 'sku = ?', whereArgs: [sku]);
  }

  Future<void> loadInitialProducts() async {
    final products = [
      {
        'productCode': 'ABC123',
        'sku': 'ABC123-001',
        'description': 'Artículo de prueba',
        'packagingUnit': 'Caja',
        'salePrice': 15.00,
      },
      {
        'productCode': 'DEF456',
        'sku': 'DEF456-002',
        'description': 'Otro artículo',
        'packagingUnit': 'Bolsa',
        'salePrice': 20.00,
      },
    ];

    for (final product in products) {
      await _db.insert('products', product);
    }
  }

  @override
  Future<void> deleteAllProduct() async {
    await _db.delete('products', where: '1 = 1');
  }
}
