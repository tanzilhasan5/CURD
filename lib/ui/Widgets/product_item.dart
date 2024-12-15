import 'package:flutter/material.dart';
import 'package:read_write/Models/product.dart';
import 'package:read_write/ui/Widgets/Screen/update_product_screen.dart';

class ProductItem extends StatefulWidget {
  Product product;
  VoidCallback? onDeleteTab;
  ProductItem({required this.product, this.onDeleteTab});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Image(
          height: 100,
          width: 70,
          image: NetworkImage('${widget.product.image}'),
          errorBuilder: (context, error, stackTrace) {
            return Image.network(
                'https://static.thenounproject.com/png/1211233-200.png');
          },
        ),
        title: Text(widget.product.productname ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product Code: ${widget.product.productcode ?? ''}'),
            Text('Quantity:  ${widget.product.quantity ?? ''}'),
            Text('Price:  ${widget.product.unitprice ?? ''}'),
            Text('Total Price:  ${widget.product.totalprice ?? ''}'),
          ],
        ),
        trailing: Wrap(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  UpdateProductScreen.name,
                  arguments: widget.product,
                );
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: widget.onDeleteTab,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        tileColor: Colors.white,
      ),
    );
  }
}