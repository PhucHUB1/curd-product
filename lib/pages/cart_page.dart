import 'package:flutter/material.dart';
import 'package:crudproduct/models/product.dart';
import 'package:crudproduct/models/cart.dart';
import 'package:crudproduct/services/cart_service.dart';
import 'package:crudproduct/services/product_service.dart';

class CartPage extends StatefulWidget {
  final CartService cartService;

  CartPage({required this.cartService});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final CartService _cartService;
  final ProductService _productService = ProductService();
  List<CartItem> _cartItems = [];
  int _totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _cartService = widget.cartService;
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    try {
      final cartItems = await _cartService.getCartItems();
      final totalAmount = await _cartService.getTotalAmount();
      setState(() {
        _cartItems = cartItems;
        _totalAmount = totalAmount;
      });
    } catch (e) {
      print('Error loading cart items: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load cart items')),
      );
    }
  }

  Future<void> _removeFromCart(int productId) async {
    try {
      await _cartService.removeProductFromCart(productId);
      _loadCartItems(); // Reload cart items after removal
    } catch (e) {
      print('Error removing product from cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove product from cart')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _cartItems.isEmpty
                ? Center(child: Text('Your cart is empty'))
                : ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = _cartItems[index];
                return FutureBuilder<Product?>(
                  future: _productService.getProductById(cartItem.productId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error fetching product'));
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Center(child: Text('Product not found'));
                    }

                    final product = snapshot.data!;
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('${product.price} x ${cartItem.quantity}'),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_shopping_cart),
                        onPressed: () => _removeFromCart(product.id!),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Total: \$${_totalAmount.toStringAsFixed(2)}'),
          ),
        ],
      ),
    );
  }
}
