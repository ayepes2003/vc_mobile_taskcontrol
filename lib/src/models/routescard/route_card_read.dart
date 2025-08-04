import 'package:vc_taskcontrol/src/models/routescard/route_card.dart';

class RouteCardRead {
  final RouteCard? card; // Modelo ruta
  final int enteredQuantity;
  final DateTime readAt;
  final int? difference; // Diferencia opcional pasada desde DB
  final String? status;
  final String? deviceId;
  final int? syncAttempts;

  // Campos nuevos para contexto
  final String? supervisor;
  final String? selectedHourRange;
  final String? section;
  final String? subsection;
  final String? operator;

  final int? supervisoryId;
  final int? sectionId;
  final int? subsectionId;
  final int? operatorId;

  // Nuevo campo para diferencia acumulada
  final int? accumDiff;

  RouteCardRead({
    this.card,
    required this.enteredQuantity,
    required this.readAt,
    this.difference,
    this.status,
    this.deviceId,
    this.syncAttempts,
    this.supervisor,
    this.selectedHourRange,
    this.section,
    this.subsection,
    this.operator,
    this.supervisoryId,
    this.sectionId,
    this.subsectionId,
    this.operatorId,
    this.accumDiff,
  });

  /// Crear instancia desde Map (ejemplo desde SQLite)
  factory RouteCardRead.fromMap(Map<String, dynamic> map) {
    return RouteCardRead(
      card: map.containsKey('id') ? RouteCard.fromMap(map) : null,
      enteredQuantity: map['entered_quantity'] as int,
      difference: map['difference'] as int?,
      readAt: DateTime.tryParse(map['read_at'] ?? '') ?? DateTime.now(),
      status: map['status_id']?.toString() ?? map['status']?.toString(),
      deviceId: map['device_id'] as String?,
      syncAttempts: map['sync_attempts'] as int?,
      supervisor: map['supervisor'] as String?,
      selectedHourRange: map['selected_hour_range'] as String?,
      section: map['section'] as String?,
      subsection: map['subsection'] as String?,
      operator: map['operator'] as String?,
      supervisoryId: map['supervisory_id'] as int?,
      sectionId: map['section_id'] as int?,
      subsectionId: map['subsection_id'] as int?,
      operatorId: map['operator_id'] as int?,
      accumDiff: map['accum_diff'] as int?,
    );
  }

  /// Convertir a Map (ejemplo para guardar en SQLite)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'entered_quantity': enteredQuantity,
      'read_at': readAt.toIso8601String(),
      'difference': difference,
      'status_id': status != null ? int.tryParse(status!) : null,
      'device_id': deviceId,
      'sync_attempts': syncAttempts,
      'supervisor': supervisor,
      'selected_hour_range': selectedHourRange,
      'section': section,
      'subsection': subsection,
      'operator': operator,
      'supervisory_id': supervisoryId,
      'section_id': sectionId,
      'subsection_id': subsectionId,
      'operator_id': operatorId,
      'accum_diff': accumDiff,
    };

    // Si tienes el id en card, también lo puedes incluir como clave foranea
    if (card != null) {
      map['route_card_id'] = card!.id;
      map['code_proces'] = card!.codeProces;
    }

    return map;
  }

  /// Crear instancia desde JSON (por ejemplo recibido desde API)
  factory RouteCardRead.fromJson(Map<String, dynamic> json) {
    return RouteCardRead(
      card:
          json.containsKey('route_card')
              ? RouteCard.fromJson(json['route_card'])
              : null,
      enteredQuantity: json['entered_quantity'] ?? 0,
      difference: json['difference'],
      readAt: DateTime.tryParse(json['read_at'] ?? '') ?? DateTime.now(),
      status: json['status']?.toString(),
      deviceId: json['device_id'],
      syncAttempts: json['sync_attempts'],
      supervisor: json['supervisor'],
      selectedHourRange: json['selected_hour_range'],
      section: json['section'],
      subsection: json['subsection'],
      operator: json['operator'],
      supervisoryId: json['supervisory_id'],
      sectionId: json['section_id'],
      subsectionId: json['subsection_id'],
      operatorId: json['operator_id'],
      accumDiff: json['accum_diff'],
    );
  }

  /// Convertir a JSON (para enviar a backend)
  Map<String, dynamic> toJson() {
    return {
      'entered_quantity': enteredQuantity,
      'read_at': readAt.toIso8601String(),
      'difference': difference,
      'status': status,
      'device_id': deviceId,
      'sync_attempts': syncAttempts,
      'supervisor': supervisor,
      'selected_hour_range': selectedHourRange,
      'section': section,
      'subsection': subsection,
      'operator': operator,
      'supervisory_id': supervisoryId,
      'section_id': sectionId,
      'subsection_id': subsectionId,
      'operator_id': operatorId,
      'accum_diff': accumDiff,
      'route_card_id': card?.id,
      'code_proces': card?.codeProces,
    };
  }

  // -----------------------------------------
  // Getter para diferencia efectiva
  int get effectiveDifference {
    if (difference != null) return difference!;
    if (card == null) return 0;
    return enteredQuantity - (int.tryParse(card!.totalPiece) ?? 0);
  }

  // Getter para estado efectivo de la lectura
  String get effectiveStatus {
    if (status != null && status!.isNotEmpty) {
      switch (status!.toLowerCase()) {
        case '0':
        case 'pending':
          return 'Pending';
        case '1':
        case 'read':
          return 'Leido';
        case '2':
        case 'terminated':
          return 'Terminado';
        default:
          return status!;
      }
    }
    if (card == null) return 'Pendiente';
    if (enteredQuantity == (int.tryParse(card!.quantity) ?? 0))
      return 'Terminado';
    return 'Read';
  }
}
