class ReadRecord {
  final String codeProces;
  final int enteredQuantity;
  final DateTime readAt;

  ReadRecord({
    required this.codeProces,
    required this.enteredQuantity,
    required this.readAt,
  });

  // Opcional: un método factory para crear una instancia desde un Map (de SQLite)
  factory ReadRecord.fromMap(Map<String, dynamic> map) {
    return ReadRecord(
      codeProces: map['code_proces'],
      enteredQuantity: map['entered_quantity'],
      readAt: DateTime.parse(map['read_at']),
    );
  }
}
