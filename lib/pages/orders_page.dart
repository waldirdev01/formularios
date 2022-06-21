import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/app_drawer.dart';
import '../components/order_widget.dart';
import '../models/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrderList>(context, listen: false).loadOrders(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              // TODO: Handle this case.
              break;
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
              // TODO: Handle this case.
              break;
            case ConnectionState.done:
              return Consumer<OrderList>(
                builder: (context, orders, child) => ListView.builder(
                    itemCount: orders.itemsCount,
                    itemBuilder: (context, index) {
                      return OrderWidget(order: orders.items[index]);
                    }),
              );
          }
          return Text('Erro inesperado');
        },
      ),
      /*body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orders.itemsCount,
              itemBuilder: (context, index) {
                return OrderWidget(order: orders.items[index]);
              }),*/
    );
  }
}
