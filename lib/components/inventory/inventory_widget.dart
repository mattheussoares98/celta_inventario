import 'package:celta_inventario/components/error_message.dart';
import 'package:celta_inventario/components/inventory/inventory_items.dart';
import 'package:celta_inventario/components/loading_process.dart';
import 'package:celta_inventario/provider/inventory_provider.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/user_identity.dart';
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

    if (!isLoaded) {
      Provider.of<InventoryProvider>(context, listen: false).getInventory(
        enterpriseCode: widget.enterpriseCode,
        userIdentity: UserIdentity.identity,
        baseUrl: BaseUrl.url,
      );
      isLoaded = true;
    }
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
            text: 'Consultando inventários',
          ),
        if (!inventoryProvider.isChargingInventorys &&
            inventoryProvider.inventoryCount > 0)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Selecione o inventário',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              InventoryItems(),
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
                      inventoryProvider.getInventory(
                        enterpriseCode: widget.enterpriseCode,
                        userIdentity: UserIdentity.identity,
                        baseUrl: BaseUrl.url,
                      );
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
