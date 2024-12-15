import 'package:flutter/material.dart';
import 'package:read_write/Models/product.dart';
import 'package:read_write/ui/Widgets/Screen/add_new_product_screen.dart';
import 'package:read_write/ui/Widgets/Screen/product_list_screen.dart';
import 'package:read_write/ui/Widgets/Screen/update_product_screen.dart';
class CRUDApp extends StatelessWidget {
  const CRUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        late Widget widget;
        if (settings.name == '/') {
          widget = const ProductListScreen();
        } else if (settings.name == AddProductScreen.name) {
          widget = const AddProductScreen();
        } else if (settings.name == UpdateProductScreen.name) {
          final Product product = settings.arguments as Product;
          widget = UpdateProductScreen(product: product);
        }

        return MaterialPageRoute(
          builder: (context) {
            return widget;
          },
        );
      },
    );
  }
}