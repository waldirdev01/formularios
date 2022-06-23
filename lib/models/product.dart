import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:formularios/utils/constants.dart';
import 'package:http/http.dart' as http;

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

  /* Pessoa.fromJson(dynamic map)
      : nome = map[kPessoaNomeColumn],
        apelido = map[kPessoaApelidoColumn],
        foto = map[kPessoaFotoColumn],
        id = map[kPessoaIdColumn],
        nomeMae = map[kPessoaMae],
        endereco = map[kPessoaEndereco],
        telefone = map[kPessoaTelefone],
        anotacoes = map[kPessoaAnotacoes];*/

  Map<String, Object> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'isFavorite': isFavorite,
    };
  }

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token) async {
    try {
      _toggleFavorite();
      final response =
          await http.patch(Uri.parse('$PRODUCT_BASE_URL/$id.json?auth=$token'),
              body: jsonEncode({
                ' isFavorite': isFavorite,
              }));
      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
    } catch (_) {
      _toggleFavorite();
    }
  }
}
