import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/cart_item_widget.dart';
import '../models/cart.dart';
import '../models/order_list.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final items = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  width: 10,
                ),
                Chip(
                  label: Text('R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 20)),
                ),
                const Spacer(),
                CartButton(cart: cart)
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return CartItemWidget(cartItem: items[index]);
                  }))
        ],
      ),
    );
  }
}

class CartButton extends StatefulWidget {
  const CartButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    return _isloading
        ? CircularProgressIndicator()
        : TextButton(
            onPressed: widget.cart.itemsCount == 0
                ? null
                : () async {
                    setState(() => _isloading = true);
                    await Provider.of<OrderList>(context, listen: false)
                        .addOrder(widget.cart);
                    setState(() => _isloading = false);
                    widget.cart.clear();
                  },
            child: const Text('COMPRAR'));
  }
}
