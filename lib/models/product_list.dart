import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:formularios/models/product.dart';

import '../data/dumy_data.dart';

class ProductList with ChangeNotifier {
  final _baseUrl = 'https://shop-cod3r-5dfd9-default-rtdb.firebaseio.com';
  final List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];

  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  void saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
        id: hasId ? data['id'] as String : Random().nextDouble().toString(),
        name: data['name'] as String,
        description: data['description'] as String,
        imageUrl: data['urlImage'] as String,
        price: data['price'] as double);
    if (hasId) {
      updateProduct(product);
    } else {
      addProduct(product);
    }
  }

  void addProduct(Product product) {
    final future = http.post(Uri.parse('$_baseUrl/products.json'),
        body: jsonEncode(
            product.toJson())); //.json é obrigatório para o Firebase realtiime
    future.then((response) {
      // print(jsonDecode(response.body)); // para saber o que eu recebi de volta do firebase: retornou {name: -N51fzRx0lBTREWTBpF7}
      // com os dados obtidos acima, vou criar um produto com o id (nome) que veio do firebase
      final id = jsonDecode(response.body)['name'];

      _items.add(Product(
          id: id,
          name: product.name,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
          isFavorite: product.isFavorite));
      notifyListeners();
    });
  }

  void updateProduct(Product product) {
    int index = _items.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(Product product) {
    int index = _items.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      _items.removeWhere((element) => element.id == product.id);
      notifyListeners();
    }
  }
}
//Todo o código abaixo era um comando global para controle de favoritos
/*bool _showFavoriteOnly = false;

List<Product> get items {
  if (_showFavoriteOnly) {
    return _items.where((product) => product.isFavorite).toList();
  }
  return [..._items];
}

void showFavoriteOnly() {
  _showFavoriteOnly = true;
  notifyListeners();
}

void showAll() {
  _showFavoriteOnly = false;
  notifyListeners();
}*/
