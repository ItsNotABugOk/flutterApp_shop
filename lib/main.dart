import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/models/providers/cart.dart';
import 'package:shop/models/providers/orders.dart';
import 'package:shop/views/screens/edit_product_screen.dart';
import 'package:shop/views/screens/shoping_cart_screen.dart';
import 'package:shop/views/screens/user_product_screen.dart';
import './views/screens/product_overview_screen.dart';
import 'models/providers/products.dart';
import 'views/screens/product_details_screen.dart';
import 'views/screens/orders_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Carts(),
        ),
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/': (ctx) => const ProductOverviewScreen(),
            ProductOverviewScreen.routeName: (ctx) =>
                const ProductOverviewScreen(),
            ProductDetailsScreen.routeName: (ctx) =>
                const ProductDetailsScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            EditProductScreen.routeName: (ctx) => const EditProductScreen(),
            UserProductScreen.routeName: (ctx) => const UserProductScreen(),
          }),
    );
  }
}
