// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/providers/product.dart';
import 'package:shop/models/providers/products.dart';

import 'product_item.dart';

// ignore: must_be_immutable
class ProductGridView extends StatelessWidget {
  final bool showFavs;

  const ProductGridView(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    List<Product> loadedProducts = showFavs
        ? productData.items.where((element) => element.favourite).toList()
        : productData.items;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: loadedProducts[index],
        child: ProductItem(),
      ),
      itemCount: loadedProducts.length,
    );
  }
}
