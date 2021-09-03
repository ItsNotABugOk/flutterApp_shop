import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/providers/orders.dart';
import 'package:shop/views/widgets/app_drawer.dart';
import 'package:shop/views/widgets/order_item.dart' as oi;

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/orders-screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  void initState() {
    // this is also True
    // Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
      setState(() {
        _isLoading = true;
      });
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      drawer: const MyAppDrawer(),
      body: _isLoading?const Center(child: CircularProgressIndicator(),) :ListView.builder(
        itemCount: orderData.ordersList.length,
        itemBuilder: (ctx, i) => oi.OrderItem(orderData.ordersList[i]),
      ),
    );
  }
}
