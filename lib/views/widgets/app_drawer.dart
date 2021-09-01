import 'package:flutter/material.dart';

import 'package:shop/views/screens/orders_screen.dart';
import 'package:shop/views/screens/product_overview_screen.dart';
import 'package:shop/views/screens/user_product_screen.dart';

class MyAppDrawer extends StatelessWidget {
  const MyAppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
        child: Column(
          children: [
            AppBar(
              title: const Text('My App'),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Shop'),
              onTap: () {
                Navigator.popAndPushNamed(
                    context, ProductOverviewScreen.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shop),
              title: const Text('Orders'),
              onTap: () {
                Navigator.popAndPushNamed(context, OrdersScreen.routeName);
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.edit),
            //   title: const Text('Edit Screen'),
            //   onTap: () {
            //     Navigator.popAndPushNamed(
            //       context,
            //       EditProductScreen.routeName,
            //     );
            //   },
            // ),

            ListTile(
              leading: const Icon(Icons.access_alarm),
              title: const Text(
                'User Products Screen',
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, UserProductScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
