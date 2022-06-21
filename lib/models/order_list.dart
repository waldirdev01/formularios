import 'dart:convert';
import 'package:formularios/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'cart.dart';
import 'order.dart';

class OrderList with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(Uri.parse('$ORDER_BASE_URL.json'),
        body: jsonEncode({
          'total': cart.totalAmount,
          'date': date.toIso8601String(),
          'products': cart.items.values.map((cartItem) => {
            'id': cartItem.id,
            'productId': cartItem.productId,
            'name': cartItem.name,
            'quantity': cartItem.quantinty,
            'price': cartItem.price,
          }).toList()
        }
            ));
   final res = jsonDecode(response.body);
   final id = res['name'];
    _items.insert(
        0,
        Order(
            id: id,
            total: cart.totalAmount,
            products: cart.items.values.toList(),
            date: date));
    notifyListeners();
  }
}
