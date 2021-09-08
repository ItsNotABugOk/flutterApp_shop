import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  late bool favourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.favourite = false,
  });

  Future<void> toggleFavoutiteProduct(String authToken, String userId) async {
    bool oldStatus = favourite;
    favourite = !favourite;
    notifyListeners();
    Uri url = Uri.parse(
        'https://online-shop-b64c2-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$authToken');
    try {
      var response = await http.Client().put(
        url,
        body: json.encode(
          favourite,
        ),
      );
      if (response.statusCode >= 400) {
        favourite = oldStatus;
        notifyListeners();
      }
    } catch (e) {
      favourite = oldStatus;
      notifyListeners();
    }
  }
}
