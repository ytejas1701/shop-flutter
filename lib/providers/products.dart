import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  String authToken;
  String userId;
  List<Product> _items = [];

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> addProduct(Product addedProduct) async {
    if (addedProduct.id != null) {
      final url = Uri.parse(
          'https://shop-app-database-92909-default-rtdb.firebaseio.com/products/${addedProduct.id}.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': addedProduct.title,
            'imageUrl': addedProduct.imageUrl,
            'price': addedProduct.price,
          }));

      final index =
          _items.indexWhere((product) => product.id == addedProduct.id);
      _items[index] = addedProduct;
      notifyListeners();
    } else {
      final url = Uri.parse(
          'https://shop-app-database-92909-default-rtdb.firebaseio.com/products.json?auth=$authToken');
      try {
        final response = await http.post(url,
            body: jsonEncode({
              'title': addedProduct.title,
              'price': addedProduct.price,
              'imageUrl': addedProduct.imageUrl,
            }));

        final newProduct = Product(
          id: jsonDecode(response.body)['name'],
          title: addedProduct.title,
          imageUrl: addedProduct.imageUrl,
          price: addedProduct.price,
        );
        _items.add(newProduct);
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  Future<void> fetchProducts() async {
    try {
      var url = Uri.parse(
          'https://shop-app-database-92909-default-rtdb.firebaseio.com/products.json?auth=$authToken');
      var response = await http.get(url);
      var productsList = json.decode(response.body) as Map<String, dynamic>;
      url = Uri.parse(
          'https://shop-app-database-92909-default-rtdb.firebaseio.com/isFavoriteData/$userId.json?auth=$authToken');
      response = await http.get(url);
      var isFavoriteData = json.decode(response.body) as Map<String, dynamic>;
      _items = [];
      if (productsList == null) return;

      productsList.forEach((prodId, prodData) {
        _items.add(Product(
            id: prodId,
            title: prodData['title'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: isFavoriteData == null
                ? false
                : isFavoriteData[prodId] ?? false));
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeProduct(String id) async {
    final url = Uri.parse(
        'https://shop-app-database-92909-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');

    final productIndex = _items.indexWhere((element) => element.id == id);
    var product = _items[productIndex];
    _items.removeAt(productIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(productIndex, product);
      notifyListeners();
      throw HttpException('Something Wrong Happened');
    }
    product = null;
  }
}
