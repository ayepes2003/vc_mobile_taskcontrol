import '../models/table_column.dart';
import 'package:flutter/material.dart';

final List<TableColumn> alarmTableColumns = [
  TableColumn(title: 'Sensor', valueBuilder: (item) => item['sensor']),
  TableColumn(
    title: 'Estado',
    valueBuilder: (item) => item['status'],
    rowColorBuilder: (item) {
      switch (item['status']) {
        case 'crítico':
          return Colors.red[100]!;
        case 'advertencia':
          return Colors.orange[100]!;
        default:
          return Colors.white;
      }
    },
  ),
];
