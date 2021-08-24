import 'package:flutter/material.dart';
import 'package:shop/models/products.dart';
import 'package:shop/views/widgets/product_gridview.dart';

class ProductOverviewScreen extends StatelessWidget {
  ProductOverviewScreen({Key? key}) : super(key: key);
  final List<Product> loadedProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 3, right: 3),
        child: ProductGridView(),
      ),
    );
  }
}
