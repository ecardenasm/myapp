import 'package:hive/hive.dart';
import 'package:myapp/core/entity/product.dart';

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0; // Asigna un typeId único para Product

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Product(
      id: fields[0] as String,
      name: fields[1] as String,
      imageUrl: fields[2] as String,
      price: fields[3] as double,
      brand: fields[4] as String,
      quantity: fields[5] as int,
      supplierPhoneNumber: fields[6] as String, // Leemos el número de teléfono
      category: fields[7] as String, // Leemos la categoría
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(8) // Número total de campos en Product (actualizado a 8)
      ..writeByte(0) // Índice del campo 'id'
      ..write(obj.id)
      ..writeByte(1) // Índice del campo 'name'
      ..write(obj.name)
      ..writeByte(2) // Índice del campo 'imageUrl'
      ..write(obj.imageUrl)
      ..writeByte(3) // Índice del campo 'price'
      ..write(obj.price)
      ..writeByte(4) // Índice del campo 'brand'
      ..write(obj.brand)
      ..writeByte(5) // Índice del campo 'quantity'
      ..write(obj.quantity)
      ..writeByte(6) // Índice del campo 'supplierPhoneNumber'
      ..write(obj.supplierPhoneNumber) // Guardamos el número de teléfono
      ..writeByte(7) // Índice del campo 'category'
      ..write(obj.category); // Guardamos la categoría
  }
}
