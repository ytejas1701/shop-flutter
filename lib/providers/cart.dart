import 'package:flutter/foundation.dart';

class CartItem {
  String productId;
  int quantity;
  String title;
  double price;

  CartItem(
      {@required this.productId,
      @required this.quantity,
      @required this.title,
      @required this.price});
}

class Cart with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items {
    return [..._items];
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((element) {
      total += element.quantity * element.price;
    });
    return total;
  }

  void addItem(String newProductId, String newTitle, double newPrice) {
    if (_items.where((element) => element.productId == newProductId).length ==
        0) {
      _items.add(CartItem(
          productId: newProductId,
          quantity: 1,
          title: newTitle,
          price: newPrice));
    } else {
      _items
          .firstWhere((element) => element.productId == newProductId)
          .quantity++;
    }
    notifyListeners();
  }

  void decreaseQuantity(String decreasedProductId) {
    if (_items
            .firstWhere((element) => element.productId == decreasedProductId)
            .quantity ==
        1) {
      _items.removeWhere((element) => element.productId == decreasedProductId);
    } else {
      _items
          .firstWhere((element) => element.productId == decreasedProductId)
          .quantity--;
    }
    notifyListeners();
  }

  void removeItem(String deletedProductId) {
    _items.removeWhere((element) => element.productId == deletedProductId);
    notifyListeners();
  }

  void clearCart() {
    _items = [];
    notifyListeners();
  }
}
