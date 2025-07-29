class ScanItem {
  final String code;
  final DateTime dateTime;
  final String deviceId;
  final String deviceModel;
  final String deviceAlias;
  final bool sent;

  ScanItem({
    required this.code,
    required this.dateTime,
    required this.deviceId,
    required this.deviceModel,
    required this.deviceAlias,
    this.sent = false,
  });

  // Aquí agregas el método copyWith:
  ScanItem copyWith({
    String? code,
    DateTime? dateTime,
    String? deviceId,
    String? deviceModel,
    String? deviceAlias,
    bool? sent,
  }) {
    return ScanItem(
      code: code ?? this.code,
      dateTime: dateTime ?? this.dateTime,
      deviceId: deviceId ?? this.deviceId,
      deviceModel: deviceModel ?? this.deviceModel,
      deviceAlias: deviceAlias ?? this.deviceAlias,
      sent: sent ?? this.sent,
    );
  }
}
