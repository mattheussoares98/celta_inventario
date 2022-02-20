import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubtractQuantityButton extends StatefulWidget {
  final int countingCode;
  final int productPackingCode;
  final Function(String) showErrorMessage;
  final String userQuantity;
  final TextEditingController controllerProduct;
  SubtractQuantityButton({
    required this.controllerProduct,
    required this.userQuantity,
    required this.showErrorMessage,
    required this.countingCode,
    required this.productPackingCode,
    Key? key,
  }) : super(key: key);

  @override
  State<SubtractQuantityButton> createState() => _SubtractQuantityButtonState();
}

class _SubtractQuantityButtonState extends State<SubtractQuantityButton> {
  @override
  Widget build(BuildContext context) {
    QuantityProvider quantityProvider = Provider.of(context, listen: true);
    ProductProvider productProvider = Provider.of(context);

    return ElevatedButton(
      onPressed: quantityProvider.isLoadingQuantity
          ? null
          : () async {
              setState(() {
                quantityProvider.isLoadingQuantity = true;
              });
              print('quantity ${widget.userQuantity}');

              try {
                await quantityProvider.subtractQuantity(
                  countingCode: widget.countingCode,
                  productPackingCode:
                      productProvider.products[0].codigoInternoProEmb,
                  quantity: '${widget.userQuantity}',
                  baseUrl: BaseUrl.url,
                  userIdentity: UserIdentity.identity,
                );
              } catch (e) {
                e;
              } finally {
                //caso o quantityError esteja diferente de '' é porque deu erro
                //pra confirmar a quantidade e por isso vai apresentar a mensagem de erro
                if (quantityProvider.quantityError != '') {
                  widget.showErrorMessage(quantityProvider.quantityError);
                  //se a quantidade for nula, nem prossegue
                  return;
                } else {
                  //como não houve erro, então pode apagar o texto que é digitado
                  //no campo de consulta do produto. Fiz passando o textEditingController
                  //como parâmetro
                  widget.controllerProduct.clear();
                }

                if (quantityProvider.isConfirmedQuantity) {
                  setState(() {
                    //pode ser que a quantidade venha como "null" na consulta do produto. Se vier como "null", precisa tratar conforme a seguir pra não dar bug. Ele verifica se veio como "null" e se sim, apresenta na numeração, "null" também
                    if (productProvider.products[0].quantidadeInvContProEmb
                            .toString() ==
                        'null') {
                      productProvider.products[0].quantidadeInvContProEmb =
                          double.tryParse(widget.userQuantity);
                    }
                    //se a mensagem de erro ou a quantidade for nula, o app não faz nada
                    if (quantityProvider.quantityError
                            .contains('não permite fracionamento') ||
                        widget.userQuantity.isEmpty) {
                      return;
                    } else {
                      productProvider.products[0].quantidadeInvContProEmb =
                          (productProvider.products[0].quantidadeInvContProEmb -
                              double.tryParse(widget.userQuantity));
                    }
                  });
                }
              }
            },
      child: quantityProvider.isLoadingQuantity
          ? FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      '\nCONFIRMANDO...\n',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                      ),
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
          : Text(
              'SUBTRAIR',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 12,
              ),
            ),
    );
  }
}
