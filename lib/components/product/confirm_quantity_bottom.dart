import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmQuantityBottom extends StatefulWidget {
  final GlobalKey<FormState> formQuantity;
  final int countingCode;
  final int productPackingCode;
  final Function(String) showErrorMessage;
  final int userQuantity;
  final TextEditingController controllerProduct;
  ConfirmQuantityBottom({
    required this.controllerProduct,
    required this.userQuantity,
    required this.showErrorMessage,
    required this.countingCode,
    required this.productPackingCode,
    required this.formQuantity,
    Key? key,
  }) : super(key: key);

  @override
  State<ConfirmQuantityBottom> createState() => _ConfirmQuantityBottomState();
}

class _ConfirmQuantityBottomState extends State<ConfirmQuantityBottom> {
  @override
  Widget build(BuildContext context) {
    QuantityProvider quantityProvider = Provider.of(context, listen: true);
    ProductProvider productProvider = Provider.of(context);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: quantityProvider.isLoadingQuantity
          ? null
          : () async {
              bool isValid = widget.formQuantity.currentState!.validate();

              if (!isValid || widget.userQuantity == 0) {
                print('a quantidade está zerada');
                return;
              }

              setState(() {
                quantityProvider.isLoadingQuantity = true;
              });

              try {
                await quantityProvider.entryQuantity(
                  countingCode: widget.countingCode,
                  productPackingCode:
                      productProvider.products[0].codigoInternoProEmb,
                  quantity: widget.userQuantity,
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
                } else {
                  //como não houve erro, então pode apagar o texto que é digitado
                  //no campo de consulta do produto. Fiz passando o textEditingController
                  //como parâmetro
                  widget.controllerProduct.clear();
                }

                if (quantityProvider.isConfirmedQuantity) {
                  setState(() {
                    //pode ser que a quantidade venha como "null" na consulta do produto. Se vier como "null", precisa tratar conforme a seguir pra não dar bug. Ele verifica se veio como "null" e se sim, apresenta na numeração, "null" também
                    productProvider.products[0].quantidadeInvContProEmb
                                .toString() ==
                            'null'
                        ? productProvider.products[0].quantidadeInvContProEmb =
                            widget.userQuantity.toDouble()
                        : productProvider.products[0].quantidadeInvContProEmb =
                            (productProvider
                                    .products[0].quantidadeInvContProEmb +
                                widget.userQuantity);
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
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                child: Text(
                  'CONFIRMAR\nQUANTIDADE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 1000,
                  ),
                ),
              ),
            ),
    );
  }
}
