// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

import 'package:shop/models/providers/product.dart';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = [
    //   Product(
    //     id: 'p1',
    //     title: 'Red Shirt',
    //     description: 'A red shirt - it is pretty red!',
    //     price: 29.99,
    //     imageUrl:
    //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //   ),
    //   Product(
    //     id: 'p2',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //   ),
    //   Product(
    //     id: 'p3',
    //     title: 'Yellow Scarf',
    //     description: 'Warm and cozy - exactly what you need for the winter.',
    //     price: 19.99,
    //     imageUrl:
    //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //   ),
    //   Product(
    //     id: 'p4',
    //     title: 'A Pan',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   ),
  ];
  final String? authToken;
  final String? userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  Product findProductById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetshAndSetProdcts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://online-shop-b64c2-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final Map<String, dynamic> extracterData = json.decode(response.body);
      url = Uri.parse(
          'https://online-shop-b64c2-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$authToken');

      final favResponse = await http.get(url);
      final favoriteData = json.decode(favResponse.body);

      final List<Product> loadedProducts = [];
      extracterData.forEach((prodId, prodvalue) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodvalue['title'],
            description: prodvalue['description'],
            price: prodvalue['price'],
            imageUrl: prodvalue['imageUrl'],
            favourite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
          ),
        );
      });

      // print(loadedProducts[0]);

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product newProduct) async {
    var url = Uri.parse(
        'https://online-shop-b64c2-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final reponse = await http.Client().post(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
          'creatorId': userId
        }),
      );
      Product newP = Product(
        id: json.decode(reponse.body)['name'],
        title: newProduct.title,
        description: newProduct.description,
        price: newProduct.price,
        imageUrl: newProduct.imageUrl,
      );
      _items.add(newP);
      notifyListeners();
    } catch (error) {
      print(' My Own Print  @@####%%%%%%%%%()  ${error.toString()}');
      rethrow;
    }
  }

  Future<void> updateProduct(String? productId, Product existingProduct) async {
    var index = _items.indexWhere((element) => element.id == productId);
    if (index >= 0) {
      var url = Uri.parse(
          'https://online-shop-b64c2-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken');
      await http.put(
        url,
        body: json.encode({
          'title': existingProduct.title,
          'description': existingProduct.description,
          'price': existingProduct.price,
          'imageUrl': existingProduct.imageUrl,
        }),
      );

      _items[index] = existingProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    var url = Uri.parse(
        'https://online-shop-b64c2-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    var existingItemIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingItem = _items[existingItemIndex];
    _items.removeAt(existingItemIndex);
    notifyListeners();
    final response = await http.Client().delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingItemIndex, existingItem);
      notifyListeners();
      throw HttpException('Could Not Delete A Product');
    }
    existingItem = null;
  }
}
