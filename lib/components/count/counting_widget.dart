import 'package:celta_inventario/components/count/counting_items.dart';
import 'package:celta_inventario/components/error_message.dart';
import 'package:celta_inventario/components/loading_process.dart';
import 'package:celta_inventario/provider/counting_provider.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountingWidget extends StatefulWidget {
  final int codigoInternoInventario;
  const CountingWidget({
    Key? key,
    required this.codigoInternoInventario,
  }) : super(key: key);

  @override
  State<CountingWidget> createState() => _CountingWidgetState();
}

class _CountingWidgetState extends State<CountingWidget> {
  bool isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isLoaded) {
      Provider.of<CountingProvider>(context, listen: false).getCountings(
        inventoryProcessCode: widget.codigoInternoInventario,
        userIdentity: UserIdentity.identity,
        baseUrl: BaseUrl.url,
      );
      isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    CountingProvider countingProvider = Provider.of(context, listen: true);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: countingProvider.isChargingCountings ||
                countingProvider.countingsErrorMessage != ''
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          if (countingProvider.isChargingCountings)
            LoadingProcess(text: 'Consultando contagens'),
          if (countingProvider.countingsErrorMessage != '')
            Column(
              children: [
                ErrorMessage(text: countingProvider.countingsErrorMessage),
                TextButton(
                  onPressed: () {
                    setState(() {
                      countingProvider.getCountings(
                        inventoryProcessCode: widget.codigoInternoInventario,
                        userIdentity: UserIdentity.identity,
                        baseUrl: BaseUrl.url,
                      );
                    });
                  },
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          if (!countingProvider.isChargingCountings &&
              countingProvider.countingsQuantity > 0)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Selecione a contagem',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                CountingItems(),
              ],
            ),
        ],
      ),
    );
  }
}
