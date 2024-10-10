class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String brand;
  final int quantity; // Agregamos un campo para la cantidad

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.brand,
    this.quantity = 1, // Valor predeterminado de cantidad
  });

  // Convertir Product a Map para guardarlo en Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'brand': brand,
      'quantity': quantity, // Agregamos la cantidad al Map
    };
  }

  // Crear un Product desde un Map (es decir, desde Firebase)
  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      brand: map['brand'] ?? '',
      quantity: map['quantity'] ?? 1, // Aseguramos que la cantidad sea leída del Map
    );
  }

  // Método de copia para crear un nuevo Product con una cantidad diferente
  Product copyWith({int? quantity}) {
    return Product(
      id: id,
      name: name,
      imageUrl: imageUrl,
      price: price,
      brand: brand,
      quantity: quantity ?? this.quantity,
    );
  }
}
