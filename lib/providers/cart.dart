import 'package:flutter/material.dart';

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

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      // change quantity
      _items.update(
          productId,
          (existingItem) => CartItem(
                id: existingItem.id,
                title: existingItem.title,
                quantity: existingItem.quantity < 4
                    ? existingItem.quantity + quantity
                    : existingItem.quantity,
                price: existingItem.price,
              ));
      quantity = 1;
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: quantity,
          price: price,
        ),
      );
      quantity = 1;
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  var quantity = 1;
  void addProductQuantity() {
    if (quantity >= 4) {
      return;
    }
    quantity += 1;
    notifyListeners();
  }

  void subProductQuantity() {
    if (quantity > 1) {
      quantity -= 1;
    }
    notifyListeners();
  }
}
