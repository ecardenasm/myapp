import 'package:hive/hive.dart';

class Product {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final double price;
  @HiveField(4)
  final String brand;
  @HiveField(5)
  final int quantity; // Agregamos un campo para la cantidad
  @HiveField(6)
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.brand,
    this.category = "",
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
      'category': category,
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
      quantity:
          map['quantity'] ?? 1, // Aseguramos que la cantidad sea leída del Map
      category: map['category'] ?? '',
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
      category: category,
    );
  }
}
