import 'package:celta_inventario/components/counting_items.dart';
import 'package:celta_inventario/components/error_message.dart';
import 'package:celta_inventario/components/loading_process.dart';
import 'package:celta_inventario/provider/counting_provider.dart';
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
  @override
  void initState() {
    super.initState();
    Provider.of<CountingProvider>(context, listen: false)
        .getCountings(widget.codigoInternoInventario);
  }

  @override
  Widget build(BuildContext context) {
    CountingProvider countingProvider = Provider.of(context, listen: true);
    return Column(
      mainAxisAlignment: countingProvider.isChargingCountings
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        if (countingProvider.isChargingCountings)
          LoadingProcess(text: 'Carregando contagens'),
        if (countingProvider.countingsErrorMessage != '')
          Column(
            children: [
              ErrorMessage(text: countingProvider.countingsErrorMessage),
              TextButton(
                onPressed: () {
                  setState(() {
                    countingProvider
                        .getCountings(widget.codigoInternoInventario);
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
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Selecione a contagem',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              CountingItems(),
            ],
          ),
      ],
    );
  }
}
