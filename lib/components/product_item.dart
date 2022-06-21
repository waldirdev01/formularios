import 'package:flutter/material.dart';
import 'package:formularios/exception/http_exception.dart';
import 'package:formularios/models/product.dart';
import 'package:formularios/models/product_list.dart';
import 'package:formularios/utils/app_routs.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(this.product, {Key? key}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.kPRODUCT_FORM, arguments: product);
                },
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                )),
            IconButton(
                onPressed: () {
                  showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text('Tem certeza?'),
                            content: const Text('Quer remover o produto?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('Não')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text('Sim')),
                            ],
                          )).then((value) async {
                    if (value ?? false) {
                      try {
                        await Provider.of<ProductList>(context, listen: false)
                            .removeProduct(product);
                      } on HttpException catch (erro) {
                        msg.showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                            content: Text(
                              erro.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            )));
                      }
                    }
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                )),
          ],
        ),
      ),
    );
  }
}
