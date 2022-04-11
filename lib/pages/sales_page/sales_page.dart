import 'package:flutter/material.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Consulta de vendas',
        ),
      ),
      body: const Center(
        child: Text(
          'Em breve...',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
