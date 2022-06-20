import 'package:flutter/material.dart';

import '../providers/counter_provider.dart';


// Recebe o produto quando clica na imagem pelo push. O classe ativa utiliza as rotas nomeadas
/*
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
*/

class CounterPage extends StatefulWidget {
  const CounterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    final provider = CounterProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Page'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(provider?.state.value.toString() ?? '0'),
            IconButton(
                onPressed: () {
                  setState(() {
                    CounterProvider.of(context)?.state.inc();
                  });
                },
                icon: const Icon(Icons.add)),
            IconButton(
                onPressed: () {
                  setState(() {
                    provider?.state.dec();
                  });
                },
                icon: const Icon(Icons.remove))
          ],
        ),
      ),
    );
  }
}
