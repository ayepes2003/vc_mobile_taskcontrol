import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/providers/pos/product_provider.dart';
import 'package:vc_taskcontrol/src/providers/pos/table_provider.dart';

class SearchProvider with ChangeNotifier {
  String _searchValue = '';

  String get searchValue => _searchValue;

  void setSearchValue(String value, BuildContext context) async {
    _searchValue = value;
    notifyListeners();

    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    final tableProvider = Provider.of<TableProvider>(context, listen: false);

    final product = productProvider.getProductBySku(value);

    if (product != null) {
      final existingItem = await tableProvider.getItemByCodeOrSku(
        product.productCode,
      );
      if (existingItem != null) {
        // Actualizar cantidad y precio total
        final updatedQuantity = existingItem['cantidad'] + 1;
        final updatedTotal = updatedQuantity * product.salePrice;

        tableProvider.updateItem({
          'codigo': product.productCode,
          'articulo': product.description,
          'precioBase': product.salePrice,
          'precioPublico': product.salePrice,
          'cantidad': updatedQuantity,
          'total': updatedTotal,
        });
      } else {
        // Agregar nuevo item a la tabla items
        tableProvider.addItem({
          'codigo': product.productCode,
          'articulo': product.description,
          'precioBase': product.salePrice,
          'precioPublico': product.salePrice,
          'cantidad': 1,
          'total': product.salePrice,
        });
      }
    }
  }

  void clearSearchValue() {
    _searchValue = '';
    notifyListeners();
  }
}
