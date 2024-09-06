import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'db12.db');

    final file = File(path);
    if (!await file.exists()) {
      // Copy database from assets to the application documents directory
      await _copyDatabaseFromAssets(path);
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _copyDatabaseFromAssets(String path) async {
    // Load database from assets
    final data = await rootBundle.load('assets/db12.db');
    final bytes = data.buffer.asUint8List();
    // Write the bytes to the file
    await File(path).writeAsBytes(bytes);
    print('Database copied from assets to $path');
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create `cart_items` table if it does not exist
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cart_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER,
        quantity INTEGER
      )
    ''');

    // Create `products` table with price as INTEGER
    await db.execute('''
      CREATE TABLE IF NOT EXISTS products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        price INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database schema updates if needed
    if (oldVersion < newVersion) {
      // Example of adding a new table or column
      // await db.execute('ALTER TABLE ...');
    }
  }

  // Helper method to check if tables exist
  Future<void> checkTables() async {
    final db = await database;
    final List<Map<String, dynamic>> cartItems = await db.query('cart_items');
    final List<Map<String, dynamic>> products = await db.query('products');
    print('Cart Items Table: $cartItems');
    print('Products Table: $products');
  }
}
