import 'package:flutter/material.dart';

class StepConfig {
  final int id;
  final String name;
  final String label;
  final int stepId;
  final IconData icon;
  final Color selectedColor;
  final Color selectedTextColor;

  StepConfig({
    required this.id,
    required this.name,
    required this.label,
    required this.stepId,
    required this.icon,
    required this.selectedColor,
    required this.selectedTextColor,
  });

  static Color _colorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  static IconData _iconFromString(String iconName) {
    switch (iconName) {
      case 'person':
        return Icons.person;
      case 'assignment':
        return Icons.assignment;
      case 'people':
        return Icons.people;
      case 'category':
        return Icons.category;
      case 'view_list':
        return Icons.view_list;
      case 'calculate':
        return Icons.calculate;
      case 'settings':
        return Icons.settings;
      case 'barcode':
        return Icons.barcode_reader;
      default:
        return Icons.help_outline;
    }
  }

  factory StepConfig.fromJson(Map<String, dynamic> json) {
    return StepConfig(
      id: json['id'],
      name: json['name'],
      label: json['label'],
      stepId: json['step_id'],
      icon: _iconFromString(json['icon']),
      selectedColor: _colorFromHex(json['selectedColor']),
      selectedTextColor: _colorFromHex(json['selectedTextColor']),
    );
  }
}
