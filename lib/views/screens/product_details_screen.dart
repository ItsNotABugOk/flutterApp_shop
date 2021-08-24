import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/products.dart';
import 'package:shop/models/providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details-screen';
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context, listen: false);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        product.items.firstWhere((element) => element.id == productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}
