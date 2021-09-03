import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/models/providers/products.dart';
import 'package:shop/views/screens/edit_product_screen.dart';
// ignore: unused_import
import 'package:shop/views/widgets/app_drawer.dart';
import 'package:shop/views/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);
  static const routeName = '/user-product';

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  EditProductScreen.routeName,
                );
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        // drawer: const MyAppDrawer(),
        body: RefreshIndicator(
          onRefresh: () => _refereshProducts(context),
          child: ListView.builder(
            itemCount: productData.items.length,
            itemBuilder: (context, index) => UserProductItem(
                productData.items[index].id,
                productData.items[index].title,
                productData.items[index].imageUrl),
          ),
        ));
  }
}

Future<void> _refereshProducts(BuildContext context) async {
  await Provider.of<Products>(context, listen: false).fetshAndSetProdcts();
}
