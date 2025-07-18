class Operator {
  final int id;
  final String name;
  final String documentNum;
  final String shift;
  final int sectionId;
  final String sectionName;
  final int subsectionId;
  final String subsectionName;

  Operator({
    required this.id,
    required this.name,
    required this.documentNum,
    required this.shift,
    required this.sectionId,
    required this.sectionName,
    required this.subsectionId,
    required this.subsectionName,
  });

  factory Operator.fromJson(Map<String, dynamic> json) {
    return Operator(
      id: json['id'],
      name: json['name'],
      documentNum: json['document_num'],
      shift: json['shift'],
      sectionId: json['sectionId'],
      sectionName: json['sectionName'],
      subsectionId: json['subsectionId'],
      subsectionName: json['subsectionName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'document_num': documentNum,
      'shift': shift,
      'sectionId': sectionId,
      'sectionName': sectionName,
      'subsectionId': subsectionId,
      'subsectionName': subsectionName,
    };
  }
}
