import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/providers/orders.dart';
import 'package:shop/views/widgets/app_drawer.dart';
import 'package:shop/views/widgets/order_item.dart' as oi;

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
        ),
        drawer: const MyAppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.error != null) {
              return const Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (context, data, child) => ListView.builder(
                  itemCount: data.ordersList.length,
                  itemBuilder: (context, index) =>
                      oi.OrderItem(data.ordersList[index]),
                ),
              );
            }
          },
        ));
  }
}
