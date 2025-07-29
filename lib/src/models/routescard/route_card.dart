class RouteCard {
  final String codeProces;
  final String routeNum;
  final String internalCode;
  final String projectName;
  final String codeDispacht;
  final String codeSalesErp;
  final String item;
  final String descriptionMaterial;
  final String pieceType;
  final String codePiece;
  final String numPiece;
  final String
  totalPiece; // Actualmente en backend mapeado desde quantity_initial
  final String labelPiece;
  final String quantity;
  final String grain;
  final String initialQuantity; // Para la transición, si la usas paralelamente
  // Campos multimedia eliminados para separar en otro modelo

  RouteCard({
    required this.codeProces,
    required this.routeNum,
    required this.internalCode,
    required this.projectName,
    required this.codeDispacht,
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
    this.initialQuantity = '',
  });

  factory RouteCard.fromJson(Map<String, dynamic> json) {
    String trimStr(dynamic value) => (value ?? '').toString().trim();

    return RouteCard(
      codeProces: trimStr(json['code_proces']),
      routeNum: trimStr(json['route_num']),
      internalCode: trimStr(json['internal_code']),
      projectName: trimStr(json['project_name']),
      codeDispacht: trimStr(json['code_dispacht']),
      codeSalesErp: trimStr(json['code_sales_erp']),
      item: trimStr(json['item']),
      descriptionMaterial: trimStr(json['description_material']),
      pieceType: trimStr(json['piece_type']),
      codePiece: trimStr(json['code_piece']),
      numPiece: trimStr(json['num_piece']),
      totalPiece: trimStr(json['total_piece']), // Mapeado desde backend
      labelPiece: trimStr(json['label_piece']),
      quantity: trimStr(json['quantity']),
      grain: trimStr(json['grain']),
      initialQuantity: trimStr(
        json['initial_quantity'] ?? '',
      ), // Para transición, opcional
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code_proces': codeProces,
      'route_num': routeNum,
      'internal_code': internalCode,
      'project_name': projectName,
      'code_dispacht': codeDispacht,
      'code_sales_erp': codeSalesErp,
      'item': item,
      'description_material': descriptionMaterial,
      'piece_type': pieceType,
      'code_piece': codePiece,
      'num_piece': numPiece,
      'total_piece': totalPiece,
      'label_piece': labelPiece,
      'quantity': quantity,
      'grain': grain,
      'initial_quantity': initialQuantity, // Opcional, si se necesita enviar
    };
  }
}
