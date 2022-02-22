import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnullQuantityBottom extends StatefulWidget {
  final Function(String) showErrorMessage;
  final int countingCode;
  final int productPackingCode;
  const AnullQuantityBottom({
    Key? key,
    required this.showErrorMessage,
    required this.countingCode,
    required this.productPackingCode,
  }) : super(key: key);

  @override
  State<AnullQuantityBottom> createState() => _AnullQuantityBottomState();
}

class _AnullQuantityBottomState extends State<AnullQuantityBottom> {
  anullQuantity() async {
    QuantityProvider quantityProvider = Provider.of(context, listen: false);
    ProductProvider productProvider = Provider.of(context, listen: false);
    await quantityProvider.anullQuantity(
      countingCode: widget.countingCode,
      productPackingCode: widget.productPackingCode,
      url: BaseUrl.url,
      userIdentity: UserIdentity.identity,
    );
    setState(() {
      if (quantityProvider.isConfirmedAnullQuantity) {
        productProvider.products[0].quantidadeInvContProEmb = 'null';
      }
      //caso o quantityError esteja diferente de '' é porque deu erro
      //pra confirmar a quantidade e por isso vai apresentar a mensagem de erro
      if (quantityProvider.quantityError != '') {
        widget.showErrorMessage(quantityProvider.quantityError);
      } else {
        //como não houve erro, então pode apagar o texto que é digitado
        //no campo de consulta do produto. Fiz passando o textEditingController
        //como parâmetro
        // widget.controllerProduct.clear();
      }
    });
  }

  confirmAnullQuantity(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            'DESEJA ANULAR A QUANTIDADE?',
            // textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    onPressed: () {
                      anullQuantity();
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: const Text(
                        'SIM',
                        style: TextStyle(
                          fontSize: 300,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 50),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: const Text(
                        'NÃO',
                        style: TextStyle(
                          fontSize: 300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    QuantityProvider quantityProvider = Provider.of(context, listen: true);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
      ),
      onPressed: quantityProvider.isLoadingQuantity
          ? null
          : () {
              confirmAnullQuantity(context);
            },
      child: quantityProvider.isLoadingQuantity
          ? FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    '\nCONFIRMANDO...\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Container(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          : FittedBox(
              child: Text(
                'ANULAR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 1000,
                ),
              ),
            ),
    );
  }
}
