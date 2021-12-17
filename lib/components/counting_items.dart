import 'package:celta_inventario/provider/counting_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountingItems extends StatelessWidget {
  const CountingItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CountingProvider countingProvider = Provider.of(context);
    return Container(
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
                  Text(countingProvider.countings[index].codigoInternoInvCont
                      .toString()),
                  Text(countingProvider.countings[index].codigoInternoInventario
                      .toString()),
                  Text(countingProvider.countings[index].flagTipoContagemInvCont
                      .toString()),
                  Text(countingProvider.countings[index].numeroContagemInvCont
                      .toString()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
