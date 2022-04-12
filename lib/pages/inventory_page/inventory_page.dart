import 'package:celta_inventario/utils/error_message.dart';
import 'package:celta_inventario/pages/inventory_page/inventory_items.dart';
import 'package:celta_inventario/models/enterprise.dart';
import 'package:celta_inventario/pages/inventory_page/inventory_provider.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/consulting_widget.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  tryAgain() {
    Enterprise enterprise =
        ModalRoute.of(context)!.settings.arguments as Enterprise;

    InventoryProvider inventoryProvider = Provider.of(
      context,
      listen: true,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ErrorMessage(text: inventoryProvider.errorMessage),
        TextButton(
          onPressed: () {
            setState(() {
              inventoryProvider.getInventory(
                enterpriseCode: enterprise.codigoInternoEmpresa.toString(),
                userIdentity: UserIdentity.identity,
                baseUrl: BaseUrl.url,
              );
            });
          },
          child: const Text('Tentar novamente'),
        ),
      ],
    );
  }

  bool _isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Enterprise enterprise =
        ModalRoute.of(context)!.settings.arguments as Enterprise;

    if (!_isLoaded) {
      Provider.of<InventoryProvider>(context, listen: false).getInventory(
        enterpriseCode: enterprise.codigoInternoEmpresa.toString(),
        userIdentity: UserIdentity.identity,
        baseUrl: BaseUrl.url,
      );
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    InventoryProvider inventoryProvider = Provider.of(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'INVENTÁRIOS',
        ),
      ),
      body: inventoryProvider.isLoadingInventorys
          ? ConsultingWidget()
              .consultingWidget(title: 'Consultando inventários')
          : inventoryProvider.errorMessage != ''
              ? tryAgain()
              : InventoryItems(),
    );
  }
}
