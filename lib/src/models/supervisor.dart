class Supervisor {
  final int id;
  final String name;
  final String documentNum;
  final String turno;

  Supervisor({
    required this.id,
    required this.name,
    required this.documentNum,
    required this.turno,
  });

  factory Supervisor.fromJson(Map<String, dynamic> json) {
    return Supervisor(
      id: json['id'],
      name: json['name'],
      documentNum: json['document_num'],
      turno: json['turno'],
    );
  }
}
