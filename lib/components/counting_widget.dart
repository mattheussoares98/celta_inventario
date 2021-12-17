import 'package:celta_inventario/provider/counting_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
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
      children: [
        if (countingProvider.isChargingCountings)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: const [
                  Text(
                    'Carregando contagens',
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
        if (countingProvider.countingsErrorMessage != '')
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    countingProvider.countingsErrorMessage,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
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
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
            ),
            height: 200,
            child: ListView.builder(
              itemCount: countingProvider.countingsQuantity,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      APPROUTES.PRODUCTS,
                      arguments: countingProvider.countings[index],
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    height: 200,
                    child: Column(
                      children: [
                        Text(countingProvider.countings[index].obsInvCont),
                        Text(countingProvider
                            .countings[index].codigoInternoInvCont
                            .toString()),
                        Text(countingProvider
                            .countings[index].codigoInternoInventario
                            .toString()),
                        Text(countingProvider
                            .countings[index].flagTipoContagemInvCont
                            .toString()),
                        Text(countingProvider
                            .countings[index].numeroContagemInvCont
                            .toString()),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
