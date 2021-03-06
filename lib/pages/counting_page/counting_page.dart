import 'package:celta_inventario/pages/counting_page/counting_items.dart';
import 'package:celta_inventario/utils/error_message.dart';
import 'package:celta_inventario/models/inventory_model.dart';
import 'package:celta_inventario/pages/counting_page/counting_provider.dart';
import 'package:celta_inventario/utils/consulting_widget.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountingPage extends StatefulWidget {
  const CountingPage({Key? key}) : super(key: key);

  @override
  State<CountingPage> createState() => _CountingPageState();
}

class _CountingPageState extends State<CountingPage> {
  tryAgain() {
    final inventorys =
        ModalRoute.of(context)!.settings.arguments as InventoryModel;

    CountingProvider countingProvider = Provider.of(context, listen: true);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ErrorMessage(text: countingProvider.errorMessage),
        TextButton(
          onPressed: () {
            countingProvider.getCountings(
              inventoryProcessCode: inventorys.codigoInternoInventario,
              userIdentity: UserIdentity.identity,
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
    CountingProvider countingProvider = Provider.of(context, listen: true);

    if (!isLoaded) {
      countingProvider.getCountings(
        inventoryProcessCode: inventorys.codigoInternoInventario,
        userIdentity: UserIdentity.identity,
      );
    }
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    CountingProvider countingProvider = Provider.of(context, listen: true);

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
              : const CountingItems(),
    );
  }
}
          // codigoInternoInventario: inventorys.codigoInternoInventario,
