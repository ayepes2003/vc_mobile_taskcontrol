abstract class ProductStorage {
  Future<List<Map<String, dynamic>>> loadProducts(); // Leer todos los productos
  Future<void> addProduct(Map<String, dynamic> product); // Agregar un producto
  Future<void> updateProduct(
    Map<String, dynamic> product,
  ); // Actualizar un producto
  Future<void> deleteProduct(String sku); // Eliminar un producto por SKU
  Future<void> deleteAllProduct(); // empty table
}
