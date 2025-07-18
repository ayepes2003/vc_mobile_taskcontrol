// lib/src/models/color_rule.dart
import 'package:flutter/material.dart';

class ColorRule {
  final String sourceColumn; // Columna que define el color (ej: "estado")
  final dynamic value; // Valor a comparar (ej: "crítico")
  final Color color; // Color a aplicar

  const ColorRule({
    required this.sourceColumn,
    required this.value,
    required this.color,
  });
}
