

import 'package:crudproduct/config/database_helper.dart';
import 'package:crudproduct/models/product.dart';
import 'package:sqflite/sqflite.dart';

import '../models/cart.dart';

class CartService {
  Future<void> addProductToCart(Product product) async {
    final db = await DatabaseHelper().database;
    final existingItem = await db.query(
      'cart_items',
      where: 'productId = ?',
      whereArgs: [product.id],
    );

    if (existingItem.isNotEmpty) {
      final currentQuantity = existingItem.first['quantity'] as int;
      await db.update(
        'cart_items',
        {'quantity': currentQuantity + 1},
        where: 'productId = ?',
        whereArgs: [product.id],
      );
    } else {
      await db.insert(
        'cart_items',
        {'productId': product.id, 'quantity': 1},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> removeProductFromCart(int productId) async {
    final db = await DatabaseHelper().database;
    final existingItem = await db.query(
      'cart_items',
      where: 'productId = ?',
      whereArgs: [productId],
    );

    if (existingItem.isNotEmpty) {
      final currentQuantity = existingItem.first['quantity'] as int;
      if (currentQuantity > 1) {
        await db.update(
          'cart_items',
          {'quantity': currentQuantity - 1},
          where: 'productId = ?',
          whereArgs: [productId],
        );
      } else {
        await db.delete(
          'cart_items',
          where: 'productId = ?',
          whereArgs: [productId],
        );
      }
    }
  }

  Future<List<CartItem>> getCartItems() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('cart_items');

    return List.generate(maps.length, (i) {
      return CartItem.fromMap(maps[i]);
    });
  }

  Future<int> getTotalAmount() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> cartItems = await db.query('cart_items');

    int total = 0;

    for (var item in cartItems) {
      final productId = item['productId'] as int;
      final quantity = item['quantity'] as int;

      final List<Map<String, dynamic>> product = await db.query(
        'products',
        where: 'id = ?',
        whereArgs: [productId],
      );

      if (product.isNotEmpty) {
        final price = product.first['price'] as int;
        total += price * quantity;
      }
    }

    return total;
  }
}
