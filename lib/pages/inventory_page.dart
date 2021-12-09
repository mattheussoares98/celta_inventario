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
  void initState() {
    // Enterprise enterpriseCode =
    //     ModalRoute.of(context)!.settings.arguments as Enterprise;
    super.initState();

    // Provider.of<InventoryProvider>(context).getInventory(enterpriseCode);
  }

  @override
  Widget build(BuildContext context) {
    Enterprise enterprise =
        ModalRoute.of(context)!.settings.arguments as Enterprise;

    return Scaffold(
      appBar: AppBar(
        title: const Text('INVENTÁRIOS'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                Provider.of<InventoryProvider>(context, listen: false)
                    .getInventory(enterprise.codigoInternoEmpresa.toString());
              });
            },
            child: const Text('Get inventorys'),
          ),
          Text(enterprise.codigoInternoEmpresa.toString()),
        ],
      ),
    );
  }
}
