import 'package:celta_inventario/provider/login_provider.dart';
import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnullQuantityBottom extends StatefulWidget {
  final Function(String) showErrorMessage;
  final int countingCode;
  final int productPackingCode;
  final TextEditingController controllerProduct;
  const AnullQuantityBottom({
    Key? key,
    required this.controllerProduct,
    required this.showErrorMessage,
    required this.countingCode,
    required this.productPackingCode,
  }) : super(key: key);

  @override
  State<AnullQuantityBottom> createState() => _AnullQuantityBottomState();
}

class _AnullQuantityBottomState extends State<AnullQuantityBottom> {
  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: true);
    QuantityProvider quantityProvider = Provider.of(context, listen: true);
    ProductProvider productProvider = Provider.of(context, listen: true);

    return ElevatedButton(
      onPressed: quantityProvider.isLoadingQuantity
          ? null
          : () async {
              setState(() {});
              try {
                await quantityProvider.anullQuantity(
                  countingCode: widget.countingCode,
                  productPackingCode: widget.productPackingCode,
                  url: loginProvider.userBaseUrl,
                  userIdentity: loginProvider.userIdentity,
                );
              } catch (e) {
                e;
              } finally {}
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
                  widget.controllerProduct.clear();
                }
              });
            },
      child: quantityProvider.isLoadingQuantity
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'CONFIRMANDO...',
                  style: TextStyle(
                    color: Colors.black,
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
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Text(
                'Anular quantidade',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
    );
  }
}
