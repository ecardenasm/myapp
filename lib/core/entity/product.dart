class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String brand;
  final String category;
  final String supplierPhoneNumber;
  final int quantity; // Nueva propiedad quantity

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.brand,
    required this.category,
    required this.supplierPhoneNumber,
    required this.quantity, // Asegúrate de pasar este campo en el constructor
  });

  Product copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    String? brand,
    String? category,
    String? supplierPhoneNumber,
    int?
        quantity, // Asegúrate de incluir quantity en copyWith si quieres actualizarlo
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      supplierPhoneNumber: supplierPhoneNumber ?? this.supplierPhoneNumber,
      quantity: quantity ??
          this.quantity, // Default to current quantity if not provided
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'brand': brand,
      'category': category,
      'supplierPhoneNumber': supplierPhoneNumber,
      'quantity': quantity, // Agregar quantity al mapa
    };
  }

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'],
      imageUrl: map['imageUrl'],
      price: map['price'],
      brand: map['brand'],
      category: map['category'],
      supplierPhoneNumber: map['supplierPhoneNumber'],
      quantity: map['quantity'] ?? 0, // Si quantity no está en el mapa, poner 0
    );
  }
}
