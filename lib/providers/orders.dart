import 'dart:convert';

import 'package:flutter/material.dart';
import '../providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItemM {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItemM({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final String userId;
  final String authToken;
  Orders(this.authToken, this.userId, this._orders);
  List<OrderItemM> _orders = [];
  List<OrderItemM> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://shop-app-59eb0-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    final List<OrderItemM> loadedOrders = [];
    final extractData = json.decode(response.body) as Map<String, dynamic>?;
    if (extractData == null) {
      return;
    }
    extractData.forEach(
      (orderId, orderData) {
        loadedOrders.add(
          OrderItemM(
            id: orderId,
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (items) => CartItem(
                    id: items['id'],
                    title: items['title'],
                    quantity: items['quantity'],
                    price: items['price'],
                  ),
                )
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime']),
          ),
        );
      },
    );
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final url = Uri.parse(
        'https://shop-app-59eb0-default-rtdb.firebaseio.com/Orders$userId.json?auth=$authToken');
    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList()
        },
      ),
    );
    _orders.insert(
      0,
      OrderItemM(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
