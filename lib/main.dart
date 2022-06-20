import 'package:flutter/material.dart';
import 'package:formularios/pages/cart_page.dart';
import 'package:formularios/pages/orders_page.dart';
import 'package:formularios/pages/product_detail_page.dart';
import 'package:formularios/pages/product_form_page.dart';
import 'package:formularios/pages/product_over_view_page.dart';
import 'package:formularios/pages/products_page.dart';
import 'package:formularios/utils/app_routs.dart';
import 'package:provider/provider.dart';
import 'models/cart.dart';
import 'models/order_list.dart';
import 'models/product_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductList()),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => OrderList()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //home: const ProductsOverViewPage(),
        routes: {
          AppRoutes.kHOME: (context) => const ProductsOverViewPage(),
          AppRoutes.kPRODUCTDETAIL: (context) => const ProductDetailPage(),
          AppRoutes.kCARTPAGE: (context) => const CartPage(),
          AppRoutes.kORDERS: (context) => const OrdersPage(),
          AppRoutes.kPRODUCTS: (context) => const ProductsPage(),
          AppRoutes.kPRODUCT_FORM: (context) => const ProductFormPage(),
        },
      ),
    );
  }
}
