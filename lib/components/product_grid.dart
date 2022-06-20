import 'package:flutter/material.dart';
import 'package:formularios/components/product_grid_item.dart';
import 'package:provider/provider.dart';


import '../models/product.dart';
import '../models/product_list.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    Key? key,
    required this.showFavoriteOnly,
  }) : super(key: key);
  final bool showFavoriteOnly;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts =
        showFavoriteOnly ? provider.favoriteItems : provider.items;
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: loadedProducts.length,
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
            value: loadedProducts[index],
            child: const ProductGridItem(),
          );
        });
  }
}
