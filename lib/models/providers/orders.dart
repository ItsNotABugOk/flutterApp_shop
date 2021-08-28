import 'package:flutter/foundation.dart';
import 'package:shop/models/providers/cart.dart';

class OrderItem {
  final String id;
  final String title;
  final List<CartItem> products;
  final double amount;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.title,
    required this.products,
    required this.amount,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get ordersList {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        title: 'Order ${_orders.length + 1}',
        products: cartProducts,
        amount: total,
        dateTime: DateTime.now(),
      ),
    );
  }
}
