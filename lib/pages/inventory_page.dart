import 'package:celta_inventario/components/inventory_widget.dart';
import 'package:celta_inventario/models/enterprise.dart';
import 'package:celta_inventario/provider/inventory_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        title: const Text('INVENTÁRIOS'),
      ),
      body: InventoryWidget(
        enterpriseCode: enterprise.codigoInternoEmpresa.toString(),
      ),
    );
  }
}
