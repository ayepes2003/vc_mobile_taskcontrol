abstract class DataStorage {
  List<Map<String, dynamic>> get items; // Agregar esta línea
  Future<void> loadData();
  Future<void> saveData(List<Map<String, dynamic>> items);
  Future<void> addItem(Map<String, dynamic> item);
  Future<void> updateItem(Map<String, dynamic> item);
  Future<void> clearItems();
}
