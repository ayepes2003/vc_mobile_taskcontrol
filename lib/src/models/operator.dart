class Operator {
  final int id;
  final String name;
  final String documentNum;
  final int sectionId;
  final String sectionName;
  final int subsectionId;
  final String subsectionName;
  final String shift;
  final String doneType;

  Operator({
    required this.id,
    required this.name,
    required this.documentNum,
    required this.sectionId,
    required this.sectionName,
    required this.subsectionId,
    required this.subsectionName,
    required this.shift,
    required this.doneType,
  });

  factory Operator.fromJson(Map<String, dynamic> json) {
    return Operator(
      id: json['id'],
      name: json['name'],
      documentNum: json['document_num'],
      sectionId: json['sectionId'],
      sectionName: json['sectionName'],
      subsectionId: json['subsectionId'],
      subsectionName: json['subsectionName'],
      shift: json['shift'],
      doneType: json['done_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'document_num': documentNum,
      'sectionId': sectionId,
      'sectionName': sectionName,
      'subsectionId': subsectionId,
      'subsectionName': subsectionName,
      'shift': shift,
      'done_type': doneType,
    };
  }
}
