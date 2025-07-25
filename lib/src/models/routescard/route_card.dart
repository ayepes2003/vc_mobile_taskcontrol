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
  final String length1;
  final String width1;
  final String notesA;
  final String length2;
  final String width2;
  final String notesB;
  final String totalPiece;
  final String labelPiece;
  final String quantity;
  final String grain;
  final String imgImg1;
  final String img2;
  final String img3;
  final String img4;
  final String urlFile1;
  final String urlFile2;
  final String urlFile3;

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
    required this.length1,
    required this.width1,
    required this.notesA,
    required this.length2,
    required this.width2,
    required this.notesB,
    required this.totalPiece,
    required this.labelPiece,
    required this.quantity,
    required this.grain,
    required this.imgImg1,
    required this.img2,
    required this.img3,
    required this.img4,
    required this.urlFile1,
    required this.urlFile2,
    required this.urlFile3,
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
      length1: trimStr(json['length_1']),
      width1: trimStr(json['width_1']),
      notesA: trimStr(json['notes_a']),
      length2: trimStr(json['length_2']),
      width2: trimStr(json['width_2']),
      notesB: trimStr(json['notes_b']),
      totalPiece: trimStr(json['total_piece']),
      labelPiece: trimStr(json['label_piece']),
      quantity: trimStr(json['quantity']),
      grain: trimStr(json['grain']),
      imgImg1: trimStr(json['img_img1']),
      img2: trimStr(json['img_2']),
      img3: trimStr(json['img_3']),
      img4: trimStr(json['img_4']),
      urlFile1: trimStr(json['url_file_1']),
      urlFile2: trimStr(json['url_file_2']),
      urlFile3: trimStr(json['url_file_3']),
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
      'length_1': length1,
      'width_1': width1,
      'notes_a': notesA,
      'length_2': length2,
      'width_2': width2,
      'notes_b': notesB,
      'total_piece': totalPiece,
      'label_piece': labelPiece,
      'quantity': quantity,
      'grain': grain,
      'img_img1': imgImg1,
      'img_2': img2,
      'img_3': img3,
      'img_4': img4,
      'url_file_1': urlFile1,
      'url_file_2': urlFile2,
      'url_file_3': urlFile3,
    };
  }
}
