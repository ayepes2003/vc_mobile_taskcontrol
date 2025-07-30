class ToleranceSettings {
  final int id;
  final int tolerance;
  final int toleranceDifference;

  ToleranceSettings({
    required this.id,
    required this.tolerance,
    required this.toleranceDifference,
  });

  factory ToleranceSettings.fromJson(Map<String, dynamic> json) {
    return ToleranceSettings(
      id: json['id'] ?? 0,
      tolerance: json['tolerance'] ?? 0,
      toleranceDifference: json['toleranceDifference'] ?? 0,
    );
  }
}
