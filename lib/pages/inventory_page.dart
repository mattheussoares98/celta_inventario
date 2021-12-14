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

    InventoryProvider inventoryProvider = Provider.of(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('INVENTÁRIOS'),
      ),
      body: Column(
        children: [
          if (inventoryProvider.isChargingInventorys)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: const [
                    Text(
                      'Carregando inventários',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          InventoryWidget(
            enterpriseCode: enterprise.codigoInternoEmpresa.toString(),
          ),
        ],
      ),
    );
  }
}
