// lib/models/routescard/route_card_local.dart
class RouteCardLocal {
  final int id;
  final String codeProces;
  final String routeNum;
  final String codePiece;
  final String item;
  final String descriptionMaterial;
  final String totalPiece;
  final String quantity;
  final String initialQuantity;
  final String totalPieceBase;
  final String sectionId;
  final String sectionName;
  final int statusId;
  final String deviceId;
  final String captureDate;
  final String statusDescription;

  RouteCardLocal({
    required this.id,
    required this.codeProces,
    required this.routeNum,
    required this.codePiece,
    required this.item,
    required this.descriptionMaterial,
    required this.totalPiece,
    required this.quantity,
    required this.initialQuantity,
    required this.totalPieceBase,
    required this.sectionId,
    required this.sectionName,
    required this.statusId,
    required this.deviceId,
    required this.captureDate,
    required this.statusDescription,
  });

  factory RouteCardLocal.fromMap(Map<String, dynamic> map) {
    return RouteCardLocal(
      id: map['card_id'] as int,
      codeProces: map['card_code_proces']?.toString() ?? '',
      routeNum: map['route_num']?.toString() ?? '',
      codePiece: map['code_piece']?.toString() ?? '',
      item: map['item_code']?.toString() ?? '',
      descriptionMaterial: map['description']?.toString() ?? '',
      totalPiece: map['initial_quantity']?.toString() ?? '',
      quantity: map['quantity']?.toString() ?? '',
      initialQuantity: map['initial_quantity']?.toString() ?? '',
      totalPieceBase: map['total_piece_base']?.toString() ?? '',
      sectionId: map['section_id']?.toString() ?? '',
      sectionName: map['section_name']?.toString() ?? '',
      statusId: map['card_status_id'] as int? ?? 0,
      deviceId: map['card_device_id']?.toString() ?? '',
      captureDate: map['capture_date']?.toString() ?? '',
      statusDescription: map['update_timestamp']?.toString() ?? '',
    );
  }
}
