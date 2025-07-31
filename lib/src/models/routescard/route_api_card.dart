/*class RouteApiCard {
  final String codeProces; // Mapea a 'code_proces'
  final String routeNum; // 'route_num'
  final String internalCode; // 'internal_code'
  final String projectName; // 'project_name'
  final String projectCode; // 'project_code'
  final String codeDispatch; // 'code_dispatch'  (corrige typo)
  final String codeSalesErp; // 'code_sales_erp'
  final String item; // 'item_code'
  final String descriptionMaterial; // 'description_material'
  final String pieceType; // 'piece_type'
  final String codePiece; // 'code_piece'
  final String numPiece; // 'piece_num'
  final String
  totalPiece; // Aquí mantienes tu mapeo, ej: 'initial_quantity' o como definiste (campo único asociado)
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
  final int id; // 'id'

  RouteApiCard({
    required this.id,
    required this.codeProces,
    required this.routeNum,
    required this.internalCode,
    required this.projectName,
    required this.projectCode,
    required this.codeDispatch,
    required this.codeSalesErp,
    required this.item,
    required this.descriptionMaterial,
    required this.pieceType,
    required this.codePiece,
    required this.numPiece,
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
      codeDispatch: trimStr(json['code_dispatch']), // corregido el typo aquí
      codeSalesErp: trimStr(json['code_sales_erp']),
      item: trimStr(json['item_code']),
      descriptionMaterial: trimStr(json['description_material']),
      pieceType: trimStr(json['piece_type']),
      codePiece: trimStr(json['code_piece']),
      numPiece: trimStr(json['piece_num']),
      totalPiece: trimStr(
        json['initial_quantity'],
      ), // o el que uses para esa lógica única
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
    );
  }

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
      'item_code': item,
      'description_material': descriptionMaterial,
      'piece_type': pieceType,
      'code_piece': codePiece,
      'piece_num': numPiece,
      'initial_quantity': initialQuantity,
      'total_piece_base': totalPieceBase,
      'label_piece': labelPiece,
      'quantity': quantity,
      'grain': grain,
      'section_id': sectionId,
      'section_name': sectionName,
      'status_name': statusName,
      'status_color': statusColor,
      'status_description': statusDescription,
    };
  }
}
*/
