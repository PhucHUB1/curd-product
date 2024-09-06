class Product {
  int? id;
  String name;
  int price;
  String description;

  Product({this.id, required this.name, required this.price, required this.description});

  // Convert a Product into a Map. The keys must correspond to the column names in the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
    };
  }

  // Convert a Map into a Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      description: map['description'],
    );
  }
}
