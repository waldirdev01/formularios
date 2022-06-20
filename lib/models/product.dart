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

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
