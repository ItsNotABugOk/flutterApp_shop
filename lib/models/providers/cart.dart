import 'package:flutter/widgets.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Carts with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + 1,
              price: existingCartItem.price));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  int get getItmeCount {
    return _items.values
        .fold(0, (previousValue, element) => previousValue + element.quantity);
  }

  int get totalItemsInCart {
    return _items.length;
  }

  double get totalPrice {
    var totalPrice = 0.0;
    _items.forEach((key, value) {
      totalPrice += value.price * value.quantity;
    });
    return totalPrice;
  }

  void removeItem(String productId) {
    // if (!_items.containsKey(productId)) {
    //   return;
    // }
    // if (_items[productId]!.quantity >= 1) {
    //   _items.update(
    //       productId,
    //       (existingCartItem) => CartItem(
    //           id: existingCartItem.id,
    //           title: existingCartItem.title,
    //           quantity: existingCartItem.quantity - 1,
    //           price: existingCartItem.price));
    // }
    _items.remove(productId);
    notifyListeners();
  }

  void placeOrder() {
    _items.clear();
    notifyListeners();
  }
}
