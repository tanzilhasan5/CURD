import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:read_write/Models/product.dart';
import 'package:read_write/ui/Widgets/Screen/add_new_product_screen.dart';
import 'package:read_write/ui/Widgets/Tanzil_ProductList.dart';

import '../product_item.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> productList = [];
  bool _getProductListprogress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProuctList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Product'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                _getProuctList();
                setState(() {});
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AddProductScreen.name);
              },
              icon: const Icon(Icons.add_box_outlined)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: RefreshIndicator(
          color: Colors.black,
          backgroundColor: Colors.white,
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 2));
            _getProuctList();
            setState(() {});
          },
          child: Visibility(
            visible: _getProductListprogress == false,
            replacement: const TanzilProductList(),
            child: ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return ProductItem(
                  product: productList[index],
                  onDeleteTab: () {
                    // TODO Delete
                    _deleteItemDialog(productList[index], index);
                    setState(() {});
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Api call : Get Product List
  Future<void> _getProuctList() async {
    _getProductListprogress = true;
    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/ReadProduct');
    Response response = await get(uri);
    print(response.body);
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);

      if (productList.isNotEmpty) productList.clear();

      for (Map<String, dynamic> p in decodedData['data']) {
        Product product = Product(
          id: p['_id'],
          productname: p['ProductName'],
          productcode: p['ProductCode'],
          quantity: p['Qty'],
          unitprice: p['UnitPrice'],
          image: p['Img'],
          totalprice: p['TotalPrice'],
          createddate: p['CreatedDate'],
        );
        productList.add(product);
      }
      setState(() {});
    }

    _getProductListprogress = false;
    setState(() {});
  }

  // TODO Show Delete Item Dialog
  void _deleteItemDialog(Product product, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure? Will you delete this product?'),
          backgroundColor: Colors.white,
          content: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(color: Colors.grey)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Image(
                    height: 100,
                    width: 70,
                    image: NetworkImage('${product.image}'),
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                          'https://static.thenounproject.com/png/1211233-200.png');
                    },
                  ),
                  title: Text(product.productname ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product Code: ${product.productcode ?? ''}'),
                      Text('Quantity:  ${product.quantity ?? ''}'),
                      Text('Price:  ${product.unitprice ?? ''}'),
                      Text('Total Price:  ${product.totalprice ?? ''}'),
                    ],
                  ),
                  tileColor: Colors.white,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.grey)),
              child: const Text(
                'NO',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  _deletedProduct('${product.id}', index);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'YES',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        );
      },
    );
  }

  /// Delete Product API Call
  Future<void> _deletedProduct(String ID, int index) async {
    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/DeleteProduct/$ID');
    Response response = await get(uri);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Delete confirm'),
        ),
      );

      productList.removeAt(index);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleting process "False" ID:$ID'),
        ),
      );
    }
    setState(() {});
  }
}