import 'package:celta_inventario/provider/counting_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountingItems extends StatelessWidget {
  const CountingItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CountingProvider countingProvider = Provider.of(context, listen: true);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Selecione a contagem',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Expanded(
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
                //sem esse Card, não funciona o gesture detector no campo inteiro
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Número da contagem: ',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                            Text(
                              countingProvider
                                  .countings[index].numeroContagemInvCont
                                  .toString(),
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Observações: ',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            if (countingProvider
                                    .countings[index].obsInvCont.length <
                                19)
                              Expanded(
                                child: Text(
                                  countingProvider.countings[index].obsInvCont,
                                ),
                              ),
                          ],
                        ),
                        if (countingProvider
                                .countings[index].obsInvCont.length >
                            19)
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  countingProvider.countings[index].obsInvCont,
                                  style: const TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
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
        ),
      ],
    );
  }
}
