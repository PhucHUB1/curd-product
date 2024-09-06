import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class EditProductPage extends StatefulWidget {
  final Product product;

  EditProductPage({required this.product});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _price;
  late String _description;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _name = widget.product.name;
    _price = widget.product.price;
    _description = widget.product.description;
  }

  void _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Product updatedProduct = Product(
        id: widget.product.id,
        name: _name,
        price: _price,
        description: _description,
      );

      try {
        await apiService.updateProduct(widget.product.id, updatedProduct);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product updated successfully!')),
        );
        Navigator.pop(context); // Quay lại trang trước
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update product')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _price = double.parse(value!);
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProduct,
                child: Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
