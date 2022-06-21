import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/app_drawer.dart';
import '../components/order_widget.dart';
import '../models/order_list.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<OrderList>(context, listen: false)
        .loadOrders()
        .then((_) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orders.itemsCount,
              itemBuilder: (context, index) {
                return OrderWidget(order: orders.items[index]);
              }),
    );
  }
}
