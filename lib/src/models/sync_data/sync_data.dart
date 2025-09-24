// Modelo para resultados
class SyncResult {
  final int successful;
  final int failed;
  // final int duplicates;
  final int? total;
  final String? error;

  SyncResult({
    required this.successful,
    required this.failed,
    // required this.duplicates,
    this.total,
    this.error,
  });
}
