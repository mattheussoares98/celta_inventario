import 'package:celta_inventario/components/error_message.dart';
import 'package:celta_inventario/components/inventory_items.dart';
import 'package:celta_inventario/components/loading_process.dart';
import 'package:celta_inventario/provider/inventory_provider.dart';
import 'package:celta_inventario/provider/login_provider.dart';
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
  bool isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    LoginProvider loginProvider = Provider.of(context, listen: true);
    if (!isLoaded) {
      Provider.of<InventoryProvider>(context, listen: false).getInventory(
        enterpriseCode: widget.enterpriseCode,
        userIdentity: loginProvider.userIdentity,
        baseUrl: loginProvider.userBaseUrl,
      );
      isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableSize = MediaQuery.of(context)
            .size
            .height - //altura total do dispositivo
        65 - //altura do appBar
        40 - //altura do título
        10 - //padding
        MediaQuery.of(context).padding.top; //altura da barra de notificações

    InventoryProvider inventoryProvider = Provider.of(context, listen: true);
    LoginProvider loginProvider = Provider.of(context, listen: true);
    return Container(
      child: Column(
        mainAxisAlignment: inventoryProvider.isChargingInventorys ||
                (inventoryProvider.inventoryErrorMessage != '' &&
                    !inventoryProvider.isChargingInventorys)
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          if (inventoryProvider.isChargingInventorys)
            const LoadingProcess(
              text: 'Consultando inventários',
            ),
          if (!inventoryProvider.isChargingInventorys &&
              inventoryProvider.inventoryCount > 0)
            Container(
              height: availableSize,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Selecione o inventário',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  InventoryItems(),
                ],
              ),
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
                        inventoryProvider.getInventory(
                          enterpriseCode: widget.enterpriseCode,
                          userIdentity: loginProvider.userIdentity,
                          baseUrl: loginProvider.userBaseUrl,
                        );
                      });
                    },
                    child: const Text('Tentar novamente'),
                  ),
              ],
            )
        ],
      ),
    );
  }
}
