import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  double amount;
  List<CartItem> listItems;
  DateTime date;

  OrderItem(
      {@required this.amount, @required this.date, @required this.listItems});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;
  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        'https://shop-app-database-92909-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    try {
      final response = await http.get(url);
      var ordersList = json.decode(response.body) as Map<String, dynamic>;
      _orders = [];
      if (ordersList == null) return;
      ordersList.forEach((itemId, itemData) {
        _orders.insert(
            0,
            OrderItem(
              amount: itemData['amount'],
              date: DateTime.parse(itemData['date']),
              listItems: (itemData['listItems'] as List<dynamic>)
                  .map((e) => CartItem(
                      productId: e['productId'],
                      quantity: e['quantity'],
                      title: e['title'],
                      price: e['price']))
                  .toList(),
            ));
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
    ;
  }

  Future<void> addOrder(List<CartItem> cart, double amount) async {
    final timeStamp = DateTime.now();

    final url = Uri.parse(
        'https://shop-app-database-92909-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    try {
      await http.post(url,
          body: json.encode({
            'amount': amount,
            'date': timeStamp.toIso8601String(),
            'listItems': cart
                .map((element) => {
                      'productId': element.productId,
                      'title': element.title,
                      'quantity': element.quantity,
                      'price': element.price,
                    })
                .toList(),
          }));
      _orders.insert(
          0, OrderItem(amount: amount, date: timeStamp, listItems: cart));
      notifyListeners();
    } catch (error) {}
  }
}
