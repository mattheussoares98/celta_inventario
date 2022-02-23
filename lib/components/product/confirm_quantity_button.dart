import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmQuantityButton extends StatefulWidget {
  final int countingCode;
  final int productPackingCode;
  final Function(String) showErrorMessage;
  final TextEditingController controllerConsultedProduct;
  final bool isSubtract;
  final GlobalKey<FormState> formKey;
  final void Function() alterFocusToQuantity;
  final void Function() updateLastQuantity;

  ConfirmQuantityButton({
    required this.controllerConsultedProduct,
    required this.showErrorMessage,
    required this.countingCode,
    required this.productPackingCode,
    required this.isSubtract,
    required this.formKey,
    required this.alterFocusToQuantity,
    required this.updateLastQuantity,
    Key? key,
  }) : super(key: key);

  @override
  State<ConfirmQuantityButton> createState() => _ConfirmQuantityButtonState();
}

class _ConfirmQuantityButtonState extends State<ConfirmQuantityButton> {
  confirmQuantity({
    required BuildContext context,
  }) {
    QuantityProvider quantityProvider = Provider.of(context, listen: false);

    setState(() {
      quantityProvider.isLoadingQuantity = true;
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          actionsPadding: const EdgeInsets.all(10),
          title: Text(
            'DESEJA CONFIRMAR A QUANTIDADE?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            widget.isSubtract
                ? 'Quantidade digitada: -${widget.controllerConsultedProduct.text}'
                : 'Quantidade digitada: ${widget.controllerConsultedProduct.text}',
            style: TextStyle(
              fontSize: 30,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        )),
                    onPressed: () {
                      Navigator.of(context).pop();
                      addQuantity();
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        )),
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
    setState(() {
      quantityProvider.isLoadingQuantity = false;
    });
  }

  addQuantity() async {
    QuantityProvider quantityProvider = Provider.of(context, listen: false);
    ProductProvider productProvider = Provider.of(context, listen: false);

    setState(() {
      quantityProvider.isLoadingQuantity = true;
    });

    try {
      await quantityProvider.entryQuantity(
        countingCode: widget.countingCode,
        productPackingCode: productProvider.products[0].codigoInternoProEmb,
        quantity: widget.controllerConsultedProduct.text,
        baseUrl: BaseUrl.url,
        userIdentity: UserIdentity.identity,
        isSubtract: widget.isSubtract,
      );
    } catch (e) {
      e;
    }
    if (quantityProvider.quantityError != '') {
      widget.showErrorMessage(quantityProvider.quantityError);

      widget.alterFocusToQuantity();
      return;
    }

    if (quantityProvider.isConfirmedQuantity) {
      setState(() {
        //se estiver como nulo, é porque nenhuma informação foi
        //adicionada ainda. Por isso precisa deixar o valor como '0'
        if (productProvider.products[0].quantidadeInvContProEmb.toString() ==
            'null') {
          productProvider.products[0].quantidadeInvContProEmb =
              int.tryParse('0');
        }

        if (widget.isSubtract) {
          productProvider.products[0].quantidadeInvContProEmb =
              productProvider.products[0].quantidadeInvContProEmb -
                  double.tryParse(widget.controllerConsultedProduct.text
                      .replaceAll(RegExp(r','), '.'));
        } else {
          productProvider.products[0].quantidadeInvContProEmb =
              productProvider.products[0].quantidadeInvContProEmb +
                  double.tryParse(widget.controllerConsultedProduct.text
                      .replaceAll(RegExp(r','), '.'));
        }
      });
    }
    widget.updateLastQuantity();
    widget.alterFocusToQuantity();
    widget.controllerConsultedProduct.clear();
  }

  @override
  Widget build(BuildContext context) {
    QuantityProvider quantityProvider = Provider.of(context, listen: true);

    return ElevatedButton(
      onPressed: quantityProvider.isLoadingQuantity
          ? null
          : () async {
              bool isValid = widget.formKey.currentState!.validate();

              if (!isValid) {
                return;
              }

              if (double.tryParse(widget.controllerConsultedProduct.text
                      .replaceAll(RegExp(r','), '.'))! >=
                  1000) {
                await confirmQuantity(context: context);
              } else {
                await addQuantity();
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
              padding: const EdgeInsets.all(0.0),
              child: FittedBox(
                child: Text(
                  widget.isSubtract ? 'SUBTRAIR' : 'SOMAR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 40,
                  ),
                ),
              ),
            ),
    );
  }
}
