import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/app_drawer.dart';
import '../components/badge.dart';
import '../components/product_grid.dart';
import '../models/cart.dart';
import '../models/product_list.dart';
import '../utils/app_routs.dart';

enum FilterOptions { all, favorite }

class ProductsOverViewPage extends StatefulWidget {
  const ProductsOverViewPage({Key? key}) : super(key: key);

  @override
  State<ProductsOverViewPage> createState() => _ProductsOverViewPageState();
}

class _ProductsOverViewPageState extends State<ProductsOverViewPage> {
  bool _showFavoriteOnly = false;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Loja'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Todos'),
              ),
              const PopupMenuItem(
                value: FilterOptions.favorite,
                child: Text('Favoritos'),
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.kCARTPAGE);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
            builder: (context, cart, child) => Badge(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ProductGrid(
          showFavoriteOnly: _showFavoriteOnly,
        ),
      ),
    );
  }
}
