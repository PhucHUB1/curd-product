// lib/models/cart.dart

import 'package:crudproduct/models/product.dart';

class CartItem {
  final int? id;
  final int productId;
  int quantity; // Sửa thành không phải final

  CartItem({this.id, required this.productId, required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      productId: map['productId'],
      quantity: map['quantity'],
    );
  }

  // Thêm phương thức copyWith
  CartItem copyWith({
    int? id,
    int? productId,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
    );
  }
}

class Cart {
  // Trong ngữ cảnh này, Cart chỉ là một tập hợp các CartItems.
  // Nếu bạn cần lưu trữ thông tin giỏ hàng phức tạp hơn, bạn có thể mở rộng lớp này.
  final List<CartItem> items = [];

  void addProduct(Product product) {
    // Thêm logic để xử lý việc thêm sản phẩm vào giỏ hàng.
    final existingItem = items.firstWhere(
          (item) => item.productId == product.id,
      orElse: () => CartItem(productId: product.id ?? 0, quantity: 0),
    );

    if (existingItem.quantity > 0) {
      existingItem.quantity++;
    } else {
      items.add(CartItem(productId: product.id ?? 0, quantity: 1));
    }
  }

  void removeProduct(Product product) {
    // Thêm logic để xử lý việc gỡ bỏ sản phẩm khỏi giỏ hàng.
    final existingItem = items.firstWhere(
          (item) => item.productId == product.id,
      orElse: () => CartItem(productId: product.id ?? 0, quantity: 0),
    );

    if (existingItem.quantity > 0) {
      existingItem.quantity--;
      if (existingItem.quantity == 0) {
        items.removeWhere((item) => item.productId == product.id);
      }
    }
  }

  int get totalAmount {
    // Tính tổng số tiền của các mặt hàng trong giỏ hàng.
    return items.fold(0, (sum, item) {
      // Giả sử bạn có một cách để lấy giá của sản phẩm, ví dụ như gọi dịch vụ.
      // Trong ví dụ này, giá sản phẩm được giả định là 10.
      final productPrice = 10;
      return sum + (productPrice * item.quantity);
    });
  }
}
