import 'package:flutter/material.dart';

class StockPage extends StatelessWidget {
  const StockPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Estoque',
        ),
      ),
      body: const Center(
        child: Text('Estoque'),
      ),
    );
  }
}
