import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddQuantityButton extends StatefulWidget {
  final int countingCode;
  final int productPackingCode;
  final Function(String) showErrorMessage;
  final String userQuantity;
  final TextEditingController controllerProduct;
  AddQuantityButton({
    required this.controllerProduct,
    required this.userQuantity,
    required this.showErrorMessage,
    required this.countingCode,
    required this.productPackingCode,
    Key? key,
  }) : super(key: key);

  @override
  State<AddQuantityButton> createState() => _AddQuantityButtonState();
}

class _AddQuantityButtonState extends State<AddQuantityButton> {
  @override
  Widget build(BuildContext context) {
    QuantityProvider quantityProvider = Provider.of(context, listen: true);
    ProductProvider productProvider = Provider.of(context);

    print(
        'quantidade do produto na lista ${productProvider.products[0].quantidadeInvContProEmb}');

    return ElevatedButton(
      onPressed: quantityProvider.isLoadingQuantity
          ? null
          : () async {
              setState(() {
                quantityProvider.isLoadingQuantity = true;
              });

              try {
                await quantityProvider.addQuantity(
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
                print(
                    'depois que adicionou, na lista está: ${productProvider.products[0].quantidadeInvContProEmb}');
                //caso o quantityError esteja diferente de '' é porque deu erro
                //pra confirmar a quantidade e por isso vai apresentar a mensagem de erro
              }
              if (quantityProvider.quantityError != '') {
                widget.showErrorMessage(quantityProvider.quantityError);
                return;
              } else {
                //como não houve erro, então pode apagar o texto que é digitado
                //no campo de consulta do produto. Fiz passando o textEditingController
                //como parâmetro
                widget.controllerProduct.clear();
              }

              if (quantityProvider.isConfirmedQuantity) {
                setState(() {
                  //se estiver como nulo, é porque nenhuma informação foi
                  //adicionada ainda. Por isso precisa deixar o valor como '0'
                  if (productProvider.products[0].quantidadeInvContProEmb
                          .toString() ==
                      'null') {
                    productProvider.products[0].quantidadeInvContProEmb =
                        int.tryParse('0');
                  }

                  //se houver mensagem de erro ou se não houver nada digitado,
                  //o app não faz nada
                  print(widget.userQuantity);
                  if (quantityProvider.quantityError
                          .contains('não permite fracionamento') ||
                      widget.userQuantity.isEmpty) {
                    return;
                  } else {
                    productProvider.products[0].quantidadeInvContProEmb =
                            productProvider
                                    .products[0].quantidadeInvContProEmb +
                                double.tryParse(widget.userQuantity)
                        // +
                        //     double.tryParse(widget.userQuantity
                        //         .replaceAll(RegExp(r','), '.'))
                        ;
                  }
                });
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
                  'SOMAR QUANTIDADE',
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
