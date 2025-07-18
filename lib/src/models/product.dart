class Product {
  final int id;
  final String productCode;
  final String sku; // Hacer que sku sea opcional
  final String description; // Descripción del producto
  final String packagingUnit; // Unidad de empaque (caja, unidad, etc.)
  final double salePrice; // Precio de venta del producto
  final double publicPrice;
  final double costPrice;
  final int stock;

  const Product({
    required this.id,
    required this.productCode,
    required this.sku, // Opcional
    required this.description,
    required this.packagingUnit,
    required this.salePrice,
    required this.publicPrice,
    required this.costPrice,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    print('JSON recibido: $json'); // Debug
    return Product(
      id: json['id'],
      productCode: json['productCode'],
      sku: json['sku'],
      description: json['description'], // Usa productDescription del API
      packagingUnit:
          json['packagingUnit'], // No hay campo packagingUnit en el API
      salePrice: json['salePrice'].toDouble(), // Usa publicPrice como salePrice
      publicPrice: json['publicPrice'].toDouble(),
      costPrice: json['costPrice'].toDouble(),
      stock: json['stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productCode': productCode,
      'sku': sku,
      'description': description,
      'packagingUnit': packagingUnit,
      'salePrice': salePrice,
      'publicPrice': publicPrice,
      'costPrice': costPrice,
      'stock': stock,
    };
  }
}
