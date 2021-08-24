// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/products.dart';
import 'package:shop/models/providers/products.dart';

import 'product_item.dart';

// ignore: must_be_immutable
class ProductGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    List<Product> loadedProducts = productData.items;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => ProductItem(
        loadedProducts[index].id,
        loadedProducts[index].title,
        loadedProducts[index].imageUrl,
      ),
      itemCount: loadedProducts.length,
    );
  }
}
