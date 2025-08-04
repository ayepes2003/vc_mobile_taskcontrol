class RouteCard {
  final int id; // 'id'
  final int? serverId;
  final String codeProces; // 'code_proces'
  final String routeNum; // 'route_num'
  final String internalCode; // 'internal_code'
  final String projectName; // 'project_name'
  final String projectCode; // 'project_code'
  final String codeDispatch; // 'code_dispatch' (corrige typo)
  final String codeSalesErp; // 'code_sales_erp'
  final String itemCode; // 'item_code'
  final String descriptionMaterial; // 'description_material'
  final String pieceType; // 'piece_type'
  final String codePiece; // 'code_piece'
  final String pieceNum; // 'piece_num'
  final String
  totalPiece; // aquí puedes usar 'initial_quantity' si lo quieres así,
  // o tener totalPiece y initialQuantity separados según lógica
  final String labelPiece; // 'label_piece'
  final String quantity; // 'quantity'
  final String grain; // 'grain'
  final String initialQuantity; // 'initial_quantity'
  final String totalPieceBase; // 'total_piece_base'
  final String sectionId; // 'section_id'
  final String sectionName; // 'section_name'
  final String statusName; // 'status_name'
  final String statusColor; // 'status_color'
  final String statusDescription; // 'status_description'

  // Campos locales adicionales (que no vienen por la API, son para control local y sincronización)
  final String? deviceId;
  final int? statusId;
  final int? syncAttempts;
  final String? captureDate;
  final String? updateTimestamp;

  RouteCard({
    required this.id,
    this.serverId,
    required this.codeProces,
    required this.routeNum,
    required this.internalCode,
    required this.projectName,
    required this.projectCode,
    required this.codeDispatch,
    required this.codeSalesErp,
    required this.itemCode,
    required this.descriptionMaterial,
    required this.pieceType,
    required this.codePiece,
    required this.pieceNum,
    required this.totalPiece,
    required this.labelPiece,
    required this.quantity,
    required this.grain,
    required this.initialQuantity,
    required this.totalPieceBase,
    required this.sectionId,
    required this.sectionName,
    required this.statusName,
    required this.statusColor,
    required this.statusDescription,
    this.deviceId,
    this.statusId,
    this.syncAttempts,
    this.captureDate,
    this.updateTimestamp,
  });

  factory RouteCard.fromJson(Map<String, dynamic> json) {
    String trimStr(dynamic value) => (value ?? '').toString().trim();

    return RouteCard(
      id: json['id'] ?? 0,
      codeProces: trimStr(json['code_proces']),
      routeNum: trimStr(json['route_num']),
      internalCode: trimStr(json['internal_code']),
      projectName: trimStr(json['project_name']),
      projectCode: trimStr(json['project_code']),
      codeDispatch: trimStr(json['code_dispatch']),
      codeSalesErp: trimStr(json['code_sales_erp']),
      itemCode: trimStr(json['item_code']),
      descriptionMaterial: trimStr(json['description_material']),
      pieceType: trimStr(json['piece_type']),
      codePiece: trimStr(json['code_piece']),
      pieceNum: trimStr(json['piece_num']),
      totalPiece: trimStr(json['total_piece'] ?? json['initial_quantity']),
      labelPiece: trimStr(json['label_piece']),
      quantity: trimStr(json['quantity']),
      grain: trimStr(json['grain']),
      initialQuantity: trimStr(json['initial_quantity']),
      totalPieceBase: trimStr(json['total_piece_base']),
      sectionId: trimStr(json['section_id'].toString()),
      sectionName: trimStr(json['section_name']),
      statusName: trimStr(json['status_name']),
      statusColor: trimStr(json['status_color']),
      statusDescription: trimStr(json['status_description']),
      // Campos locales no vienen en el JSON
      deviceId: trimStr(json['device_id']),
      statusId: null,
      syncAttempts: null,
      captureDate: null,
      updateTimestamp: null,
    );
  }

  /// Convertir a JSON para API (campos locales no se incluyen)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code_proces': codeProces,
      'route_num': routeNum,
      'internal_code': internalCode,
      'project_name': projectName,
      'project_code': projectCode,
      'code_dispatch': codeDispatch,
      'code_sales_erp': codeSalesErp,
      'item_code': itemCode,
      'description_material': descriptionMaterial,
      'piece_type': pieceType,
      'code_piece': codePiece,
      'piece_num': pieceNum,
      'total_piece': totalPiece,
      'label_piece': labelPiece,
      'quantity': quantity,
      'grain': grain,
      'initial_quantity': initialQuantity,
      'total_piece_base': totalPieceBase,
      'section_id': sectionId,
      'section_name': sectionName,
      'status_name': statusName,
      'status_color': statusColor,
      'status_description': statusDescription,
      // campos locales no van aquí
    };
  }

  /// Crear instancia desde Map (SQLite), incluyendo campos locales
  factory RouteCard.fromMap(Map<String, dynamic> map) {
    return RouteCard(
      id: map['id'] as int,
      codeProces: map['code_proces'] ?? '',
      routeNum: map['route_num'] ?? '',
      internalCode: map['internal_code'] ?? '',
      projectName: map['project_name'] ?? '',
      projectCode: map['project_code'] ?? '',
      codeDispatch: map['code_dispatch'] ?? '',
      codeSalesErp: map['code_sales_erp'] ?? '',
      itemCode: map['item_code'] ?? '',
      descriptionMaterial: map['description_material'] ?? '',
      pieceType: map['piece_type'] ?? '',
      codePiece: map['code_piece'] ?? '',
      pieceNum: map['piece_num'] ?? '',
      totalPiece: map['total_piece'] ?? '',
      labelPiece: map['label_piece'] ?? '',
      quantity: map['quantity'] ?? '',
      grain: map['grain'] ?? '',
      initialQuantity: map['initial_quantity'] ?? '',
      totalPieceBase: map['total_piece_base'] ?? '',
      sectionId: map['section_id']?.toString() ?? '',
      sectionName: map['section_name'] ?? '',
      statusName: map['status_name'] ?? '',
      statusColor: map['status_color'] ?? '',
      statusDescription: map['status_description'] ?? '',
      deviceId: map['device_id'],
      statusId: map['status_id'] as int?,
      syncAttempts: map['sync_attempts'] as int?,
      captureDate: map['capture_date'],
      updateTimestamp: map['update_timestamp'],
    );
  }

  /// Convertir a Map para guardar en SQLite (incluye campos locales)
  Map<String, dynamic> toMap({bool forInsert = false}) {
    final map = {
      'id': id,
      'code_proces': codeProces,
      'route_num': routeNum,
      'internal_code': internalCode,
      'project_name': projectName,
      'project_code': projectCode,
      'code_dispatch': codeDispatch,
      'code_sales_erp': codeSalesErp,
      'item_code': itemCode,
      'description_material': descriptionMaterial,
      'piece_type': pieceType,
      'code_piece': codePiece,
      'piece_num': pieceNum,
      'total_piece': totalPiece,
      'label_piece': labelPiece,
      'quantity': quantity,
      'grain': grain,
      'initial_quantity': initialQuantity,
      'total_piece_base': totalPieceBase,
      'section_id': sectionId,
      'section_name': sectionName,
      'status_name': statusName,
      'status_color': statusColor,
      'status_description': statusDescription,
      'device_id': deviceId,
      'status_id': statusId,
      'sync_attempts': syncAttempts,
      'capture_date': captureDate,
      'update_timestamp': updateTimestamp,
    };
    if (!forInsert) {
      // Solo incluye 'id' si NO es para insert (por ejemplo para update)
      map['id'] = id;
    }

    return map;
  }
}
