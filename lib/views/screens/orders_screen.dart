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
    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      drawer: const MyAppDrawer(),
      body: ListView.builder(
        itemCount: orderData.ordersList.length,
        itemBuilder: (ctx, i) => oi.OrderItem(orderData.ordersList[i]),
      ),
    );
  }
}
