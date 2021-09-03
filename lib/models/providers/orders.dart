import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shop/models/providers/cart.dart';

class OrderItem {
  final String id;
  final List<CartItem> products;
  final double amount;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.products,
    required this.amount,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  late List<OrderItem> _orders = [];

  List<OrderItem> get ordersList {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    var url = Uri.parse(
        'https://online-shop-b64c2-default-rtdb.firebaseio.com/orders.json');
    final response = await http.get(url);
    final Map<String, dynamic>? responseData = json.decode(response.body);
    if (responseData == null) {
      return;
    }
    final List<OrderItem> loadedList = [];
    responseData.forEach((orderId, orderData) {
      loadedList.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (e) => CartItem(
                    id: e['id'],
                    title: e['title'],
                    quantity: e['quantity'],
                    price: e['price']),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedList.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    var url = Uri.parse(
        'https://online-shop-b64c2-default-rtdb.firebaseio.com/orders.json');
    final DateTime dateTime = DateTime.now();
    final response = await http.Client().post(url,
        body: json.encode({
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList(),
          'amount': total,
          'dateTime': dateTime.toIso8601String(),
        }));

    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          products: cartProducts,
          amount: total,
          dateTime: dateTime),
    );
  }
}
