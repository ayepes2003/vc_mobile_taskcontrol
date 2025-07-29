class Section {
  final int id;
  final String sectionName;
  final String? subSectionName;
  final String? verbOperation;
  final List<String> measurements;
  final List<String> subsections;

  Section({
    required this.id,
    required this.sectionName,
    required this.subSectionName,
    required this.verbOperation,
    required this.measurements,
    required this.subsections,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      sectionName: json['section_name'],
      subSectionName: json['sub_section_name'],
      verbOperation: json['verb_operation'],
      measurements: List<String>.from(json['measurements'] ?? []),
      subsections: List<String>.from(json['subsections'] ?? []),
    );
  }
}
