import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      this.description = 'No Description',
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleIsFavorite(String authToken, String userId) async {
    final url = Uri.parse(
        'https://shop-app-database-92909-default-rtdb.firebaseio.com/isFavoriteData/$userId/$id.json?auth=$authToken');
    final originalValue = isFavorite;
    isFavorite = !originalValue;
    notifyListeners();
    try {
      final response = await http.put(url,
          body: json.encode(
            !originalValue,
          ));
      if (response.statusCode >= 400) {
        isFavorite = originalValue;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = originalValue;
      notifyListeners();
    }
  }
}
