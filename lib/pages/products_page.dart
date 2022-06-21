import 'package:flutter/material.dart';
import 'package:formularios/components/app_drawer.dart';
import 'package:formularios/components/product_item.dart';
import 'package:formularios/models/product_list.dart';
import 'package:formularios/utils/app_routs.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatelessWidget {
 const ProductsPage({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductList>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ProductList product = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar produtos'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.kPRODUCT_FORM);
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: ()=>_refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: product.itemsCount,
              itemBuilder: (context, index) => Column(
                    children: [
                      ProductItem(product.items[index]),
                      Divider(),
                    ],
                  )),
        ),
      ),
    );
  }
}
