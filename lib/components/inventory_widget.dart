import 'package:celta_inventario/components/error_message.dart';
import 'package:celta_inventario/components/inventory_items.dart';
import 'package:celta_inventario/components/loading_process.dart';
import 'package:celta_inventario/provider/inventory_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryWidget extends StatefulWidget {
  final String enterpriseCode;
  const InventoryWidget({
    Key? key,
    required this.enterpriseCode,
  }) : super(key: key);

  @override
  _InventoryWidgetState createState() => _InventoryWidgetState();
}

class _InventoryWidgetState extends State<InventoryWidget> {
  @override
  void initState() {
    super.initState();
    Provider.of<InventoryProvider>(context, listen: false).getInventory(
      widget.enterpriseCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    InventoryProvider inventoryProvider = Provider.of(context, listen: true);
    return Column(
      mainAxisAlignment: inventoryProvider.isChargingInventorys ||
              (inventoryProvider.inventoryErrorMessage != '' &&
                  !inventoryProvider.isChargingInventorys)
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        if (inventoryProvider.isChargingInventorys)
          const LoadingProcess(
            text: 'Carregando inventários',
          ),
        if (!inventoryProvider.isChargingInventorys &&
            inventoryProvider.inventoryCount > 0)
          Column(
            children: const [
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Selecione o inventário',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: InventoryItems(),
              ),
            ],
          ),
        if (inventoryProvider.inventoryErrorMessage != '' &&
            !inventoryProvider.isChargingInventorys)
          Column(
            children: [
              ErrorMessage(text: inventoryProvider.inventoryErrorMessage),
              if (inventoryProvider.haveError)
                TextButton(
                  onPressed: () {
                    setState(() {
                      inventoryProvider.getInventory(widget.enterpriseCode);
                    });
                  },
                  child: const Text('Tentar novamente'),
                ),
            ],
          )
      ],
    );
  }
}
