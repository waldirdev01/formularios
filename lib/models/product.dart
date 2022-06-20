import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id, name, description, imageUrl;
  final double price;
  bool isFavorite;

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavorite = false});

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
