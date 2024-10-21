import 'package:path/path.dart';
import 'package:myapp/core/entity/product.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';

class DatabaseCampus {
  // Crear la tabla cart
  final String query = 'CREATE TABLE cart(id TEXT, name TEXT, imageUrl TEXT, price REAL, brand TEXT, quantity INTEGER)';

  static final DatabaseCampus _instance = DatabaseCampus._init();
  factory DatabaseCampus() => _instance;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    if (kIsWeb) {
      // Si es web, usa inMemoryDatabasePath
      _database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath); 
    } else {
      // Si es móvil (Android o iOS), usa _initDB
      _database = await _initDB('campus.db'); 
    }

    _createDB(_database!, 1); // Asegúrate de que las tablas se crean
    return _database!;
   }


  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    return db.execute(query);
  }
  
  DatabaseCampus._init();
  // Insertar productos en la tabla cart
  Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert('cart', product.toMap());
  }

  // Obtener todos los productos de la tabla cart
  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cart');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]['id'], maps[i]);
    });
  }

  Future<void> deleteProduct(String productId) async {
    final db = await database;
    await db.delete('cart', where: 'id = ?', whereArgs: [productId]);
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update('cart', product.toMap(), where: 'id = ?', whereArgs: [product.id]);
  }
}
