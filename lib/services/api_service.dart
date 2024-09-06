import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class ApiService {
  final String apiUrl = 'https://t2210m-flutter.onrender.com/products';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data
          .where((json) => json['name'] != null)
          .map((json) => Product.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add product');
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    if (id.isEmpty) {
      throw Exception('Invalid product ID or product data');
    }

    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      // Cập nhật thành công
      return;
    } else {
      // Xử lý các trường hợp lỗi khác nhau
      String errorMessage = 'Failed to update product';
      if (response.statusCode == 404) {
        errorMessage = 'Product not found';
      } else if (response.statusCode == 400) {
        errorMessage = 'Bad request';
      } else if (response.statusCode == 500) {
        errorMessage = 'Internal server error';
      }
      throw Exception(errorMessage);
    }
  }

  Future<void> deleteProduct(String id) async {
    if (id.isEmpty) {
      throw Exception('Invalid product ID');
    }

    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 204) {
      // Xóa thành công
      return;
    } else {
      // Xử lý các trường hợp lỗi khác nhau
      String errorMessage = 'Failed to delete product';
      if (response.statusCode == 404) {
        errorMessage = 'Product not found';
      } else if (response.statusCode == 400) {
        errorMessage = 'Bad request';
      } else if (response.statusCode == 500) {
        errorMessage = 'Internal server error';
      }
      throw Exception(errorMessage);
    }
  }
}