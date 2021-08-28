import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/providers/product.dart';
import 'package:shop/views/screens/shoping_cart_screen.dart';
import 'package:shop/views/widgets/app_drawer.dart';
import 'package:shop/views/widgets/product_gridview.dart';
import 'package:shop/models/providers/cart.dart';

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);
  static const routeName = '/product-overview';

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  final List<Product> loadedProducts = [];
  var _favourites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, CartScreen.routeName);
            },
          ),
          PopupMenuButton(
            onSelected: (bool value) {
              setState(() {
                value ? _favourites = true : _favourites = false;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text('Show All'),
                value: false,
              ),
              const PopupMenuItem(
                child: Text('Only show Favourites'),
                value: true,
              ),
            ],
          ),
          Consumer<Carts>(
            builder: (context, value, child) =>
                Text('cart ${value.getItmeCount}'),
          ),
        ],
      ),
      drawer: const MyAppDrawer(),
      // ignore: prefer_const_constructors
      body: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 3, right: 3),
        child: ProductGridView(_favourites),
      ),
    );
  }
}
