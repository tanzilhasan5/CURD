import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:read_write/Models/product.dart';
class UpdateProductScreen extends StatefulWidget {
  static String name = '/update_product_screen';
  final Product product;

  const UpdateProductScreen({super.key, required this.product});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _priceTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _updateProductInProgress = false;

  @override
  void initState() {
    super.initState();
    _nameTEController.text = widget.product.productname ?? '';
    _priceTEController.text = widget.product.unitprice ?? '';
    _totalPriceTEController.text = widget.product.totalprice ?? '';
    _quantityTEController.text = widget.product.quantity ?? '';
    _imageTEController.text = widget.product.image ?? '';
    _codeTEController.text = widget.product.productcode ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Update Product'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildProductForm(),
        ),
      ),
    );
  }

  Widget _buildProductForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Name',
                labelText: 'Product name'),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter product name';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _priceTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Price',
                labelText: 'Product Price'),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter product price';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _quantityTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Quantity',
                labelText: 'Product Quantity'),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter product quantity';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _totalPriceTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Total price',
                labelText: 'Product Total Price'),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter product total price';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _codeTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Code',
                labelText: 'Product Code'),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter product code';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _imageTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Image url',
                labelText: 'Product Image'),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter product image url';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Visibility(
            visible: _updateProductInProgress == false,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _updateProduct();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text(
                'Update Product',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _updateProduct() async {
    _updateProductInProgress = true;
    setState(() {});
    Uri uri = Uri.parse(
        'https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.id}');

    Map<String, dynamic> requestBody = {
      "Img": _imageTEController.text.trim(),
      "ProductCode": _codeTEController.text.trim(),
      "ProductName": _nameTEController.text.trim(),
      "Qty": _quantityTEController.text.trim(),
      "TotalPrice": _totalPriceTEController.text.trim(),
      "UnitPrice": _priceTEController.text.trim()
    };

    Response response = await post(
      uri,
      headers: {'Content-type': 'application/json'},
      body: jsonEncode(requestBody),
    );
    _updateProductInProgress = false;
    setState(() {});
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product has been updated!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product update failed! Try again.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _codeTEController.dispose();
    _priceTEController.dispose();
    _totalPriceTEController.dispose();
    _imageTEController.dispose();
    _quantityTEController.dispose();
    super.dispose();
  }
}