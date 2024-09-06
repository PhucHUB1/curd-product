// lib/screens/product_detail_page.dart

import 'package:flutter/material.dart';
import 'package:crudproduct/models/product.dart';
import 'package:crudproduct/services/cart_service.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final CartService _cartService = CartService();

  ProductDetailPage({required this.product});

  void _addToCart(Product product) {
    _cartService.addProductToCart(product);
    print('Product added to cart: ${product.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '\$${product.price}',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 16),
            Text(product.description),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _addToCart(product),
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
