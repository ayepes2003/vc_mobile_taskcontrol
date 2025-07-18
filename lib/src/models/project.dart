class Project {
  final int id;
  final String projectName;
  final String location;
  final String codeProduction;
  final int estimatedQuantity;
  final String sectionName;
  final String subsectionName;
  final String startDate;
  final String endDate;

  Project({
    required this.id,
    required this.projectName,
    required this.location,
    required this.codeProduction,
    required this.estimatedQuantity,
    required this.sectionName,
    required this.subsectionName,
    required this.startDate,
    required this.endDate,
  });

  // Método de fábrica para crear un Project desde un Map (por ejemplo, desde JSON)
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      projectName: json['project_name'],
      location: json['location'],
      codeProduction: json['code_production'],
      estimatedQuantity: json['estimated_quantity'],
      sectionName: json['section_name'],
      subsectionName: json['subsection_name'],
      startDate: json['start_date'],
      endDate: json['end_date'],
    );
  }
}
