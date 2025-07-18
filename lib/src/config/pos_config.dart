// lib/src/config/pos_config.dart
import 'package:flutter/material.dart';

import '../models/table_column.dart';

final List<TableColumn> posTableColumns = [
  TableColumn(title: 'Código', valueBuilder: (item) => item['codigo']),
  TableColumn(title: 'Artículo', valueBuilder: (item) => item['articulo']),
  TableColumn(
    title: 'P. Base',
    valueBuilder: (item) => '\$${item['precioBase']}',
  ),
  TableColumn(
    title: 'P. Público',
    valueBuilder: (item) => '\$${item['precioPublico']}',
    rowColorBuilder:
        (item) =>
            item['precioPublico'] > 20
                ? Colors.green[100]!
                : Colors.transparent,
  ),
  TableColumn(title: 'Cant', valueBuilder: (item) => item['cantidad']),
  TableColumn(title: 'Dispath_qty', valueBuilder: (item) => item['cantidad']),
  TableColumn(title: 'Total', valueBuilder: (item) => '\$${item['total']}'),
];
