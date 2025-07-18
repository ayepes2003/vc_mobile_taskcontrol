// lib/src/models/table_column.dart
import 'package:flutter/material.dart';

class TableColumn {
  final String title;
  final dynamic Function(Map<String, dynamic> item) valueBuilder;
  final Color Function(Map<String, dynamic> item)? rowColorBuilder;
  final TextStyle Function(Map<String, dynamic> item)? textStyleBuilder;

  const TableColumn({
    required this.title,
    required this.valueBuilder,
    this.rowColorBuilder,
    this.textStyleBuilder,
  });
}
