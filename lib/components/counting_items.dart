import 'package:celta_inventario/provider/counting_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountingItems extends StatelessWidget {
  const CountingItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CountingProvider countingProvider = Provider.of(context, listen: true);

    return SizedBox(
      height: countingProvider.countings[0].obsInvCont.length > 30 ? 200 : 100,
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
            child: Card(
              elevation: 10,
              color: Colors.lightBlue[100],
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Número da contagem: ${countingProvider.countings[index].numeroContagemInvCont}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Observação: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Expanded(
                          child: Text(
                            countingProvider.countings[index].obsInvCont,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
