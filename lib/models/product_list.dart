import 'dart:convert';
import 'dart:math';
import 'package:formularios/exception/http_exception.dart';
import 'package:formularios/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:formularios/models/product.dart';

class ProductList with ChangeNotifier {
  final _baseUrl = PRODUCT_BASE_URL;
  final List<Product> _items = [];

  List<Product> get items => [..._items];

  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
        id: hasId ? data['id'] as String : Random().nextDouble().toString(),
        name: data['name'] as String,
        description: data['description'] as String,
        imageUrl: data['urlImage'] as String,
        price: data['price'] as double);
    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> loadProducts() async {
    _items.clear();
    final response = await http.get(Uri.parse('$_baseUrl.json'));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      _items.add(
        Product(
            id: productId,
            name: productData['name'],
            description: productData['description'],
            imageUrl: productData['imageUrl'],
            price: productData['price'],
            isFavorite: productData['isFavorite']),
      );
    });
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(Uri.parse('$_baseUrl.json'),
        body: jsonEncode(
            product.toJson())); //.json é obrigatório para o Firebase realtiime
    final id = jsonDecode(response.body)['name'];

    _items.add(Product(
        id: id,
        name: product.name,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        isFavorite: product.isFavorite));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      final response =
          await http.patch(Uri.parse('$_baseUrl/${product.id}.json'),
              body: jsonEncode({
                'name': product.name,
                'description': product.description,
                ' imageUrl': product.imageUrl,
                'price': product.price,
              }));

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    //exclui o prouduto no aparelho, tenta excluir no firebase e se der erro inclui o produto de olta na lista local
    int index = _items.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();
      final response = await http.delete(Uri.parse('$_baseUrl/${product.id}.json'));
      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir o produto',
          statusCode: response.statusCode,
        );
      }
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
