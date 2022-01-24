import 'package:celta_inventario/components/counting_widget.dart';
import 'package:celta_inventario/models/inventory.dart';
import 'package:flutter/material.dart';

class CountingPage extends StatefulWidget {
  const CountingPage({Key? key}) : super(key: key);

  @override
  State<CountingPage> createState() => _CountingPageState();
}

class _CountingPageState extends State<CountingPage> {
  @override
  Widget build(BuildContext context) {
    final inventorys = ModalRoute.of(context)!.settings.arguments as Inventory;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CONTAGENS',
        ),
      ),
      body: CountingWidget(
        codigoInternoInventario: inventorys.codigoInternoInventario,
      ),
    );
  }
}
