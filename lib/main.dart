import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/models/providers/cart.dart';
import 'package:shop/models/providers/orders.dart';
import 'package:shop/views/screens/edit_product_screen.dart';
import 'package:shop/views/screens/shoping_cart_screen.dart';
import 'package:shop/views/screens/user_product_screen.dart';
import './views/screens/product_overview_screen.dart';
import 'models/providers/auth.dart';
import 'models/providers/products.dart';
import 'views/screens/auth_screen.dart';
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
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products('', '', []),
          update: (context, auth, previous) =>
              Products(auth.token, auth.userId, previous!.items),
        ),
        ChangeNotifierProvider.value(
          value: Carts(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders('', '', []),
          update: (context, auth, previous) =>
              Orders(auth.token, auth.userId, previous!.ordersList),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shop App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: auth.isAuth
                ? const ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? const Center(child: CircularProgressIndicator())
                            : const AuthScreen(),
                  ),
            routes: {
              ProductOverviewScreen.routeName: (ctx) =>
                  const ProductOverviewScreen(),
              ProductDetailsScreen.routeName: (ctx) =>
                  const ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => const CartScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              EditProductScreen.routeName: (ctx) => const EditProductScreen(),
              UserProductScreen.routeName: (ctx) => const UserProductScreen(),
            }),
      ),
    );
  }
}
