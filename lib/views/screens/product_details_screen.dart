import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details-screen';
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context, listen: false);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = products.findProductById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}
