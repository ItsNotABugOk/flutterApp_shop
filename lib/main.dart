import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './views/screens/product_overview_screen.dart';
import 'models/providers/products.dart';
import 'views/screens/product_details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Products(),
      // builder: (context, _) => Products(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/': (ctx) => ProductOverviewScreen(),
            ProductDetailsScreen.routeName: (ctx) =>
                const ProductDetailsScreen(),
          }

          // home: ProductOverviewScreen(),
          ),
    );
  }
}
