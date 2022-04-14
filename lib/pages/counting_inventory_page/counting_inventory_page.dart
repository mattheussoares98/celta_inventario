import 'package:celta_inventario/models/inventory/inventory_model.dart';
import 'package:celta_inventario/pages/counting_inventory_page/counting_inventory_items.dart';
import 'package:celta_inventario/pages/counting_inventory_page/counting_inventory_provider.dart';
import 'package:celta_inventario/utils/error_message.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/consulting_widget.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountingInventoryPage extends StatefulWidget {
  const CountingInventoryPage({Key? key}) : super(key: key);

  @override
  State<CountingInventoryPage> createState() => _CountingInventoryPageState();
}

class _CountingInventoryPageState extends State<CountingInventoryPage> {
  tryAgain() {
    final inventorys =
        ModalRoute.of(context)!.settings.arguments as InventoryModel;

    CountingInventoryProvider countingProvider =
        Provider.of(context, listen: true);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ErrorMessage(text: countingProvider.errorMessage),
        TextButton(
          onPressed: () {
            countingProvider.getCountings(
              inventoryProcessCode: inventorys.codigoInternoInventario,
              userIdentity: UserIdentity.identity,
              baseUrl: BaseUrl.url,
            );
          },
          child: const Text('Tentar novamente'),
        ),
      ],
    );
  }

  bool isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final inventorys =
        ModalRoute.of(context)!.settings.arguments as InventoryModel;
    CountingInventoryProvider countingProvider =
        Provider.of(context, listen: true);

    if (!isLoaded) {
      countingProvider.getCountings(
        inventoryProcessCode: inventorys.codigoInternoInventario,
        userIdentity: UserIdentity.identity,
        baseUrl: BaseUrl.url,
      );
    }
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    CountingInventoryProvider countingProvider =
        Provider.of(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CONTAGENS',
        ),
      ),
      body: countingProvider.isLoadingCountings
          ? ConsultingWidget().consultingWidget(title: 'Consultando contagens')
          : countingProvider.errorMessage != ''
              ? tryAgain()
              : CountingInventoryItems(),
    );
  }
}
          // codigoInternoInventario: inventorys.codigoInternoInventario,
