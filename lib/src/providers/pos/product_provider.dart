import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/models/product.dart';
import 'package:vc_taskcontrol/src/storage/sqlite_product_storage.dart';

class ProductProvider with ChangeNotifier {
  final SqliteProductStorage _storage;
  List<Product> _products = [];

  List<Product> get products => _products;

  ProductProvider(this._storage);

  Future<void> loadProducts() async {
    final data = await _storage.loadProducts();
    print(data.toString());
    _products = data.map((item) => Product.fromJson(item)).toList();
    notifyListeners();
    print(_products.length);
  }

  // providers/product_provider.dart
  Future<void> addProduct(Product product) async {
    final productMap =
        product.toJson(); // Asegúrate de que Product tenga un método toJson()
    await _storage.addProduct(productMap);
    _products.add(product);
    notifyListeners();
  }

  Product? getProductBySku(String sku) {
    try {
      // return _products.firstWhere((product) => product.sku == sku);
      return _products.firstWhere(
        (product) => product.sku == sku || product.productCode == sku,
      );
    } catch (e) {
      return null;
    }
  }
}
