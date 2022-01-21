import 'package:celta_inventario/components/inventory_widget.dart';
import 'package:celta_inventario/models/enterprise.dart';
import 'package:flutter/material.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    Enterprise enterprise =
        ModalRoute.of(context)!.settings.arguments as Enterprise;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'INVENTÁRIOS',
          style: TextStyle(
            color: Colors.black,
            // fontFamily: 'BebasNeue',
            fontSize: 30,
          ),
        ),
      ),
      body: InventoryWidget(
        enterpriseCode: enterprise.codigoInternoEmpresa.toString(),
      ),
    );
  }
}
