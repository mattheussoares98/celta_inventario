import 'package:celta_inventario/controller/productPage/add_quantity_controller.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmQuantityButton extends StatefulWidget {
  final int countingCode;
  final int productPackingCode;
  final TextEditingController consultedProductController;
  final bool isSubtract;
  final GlobalKey<FormState> formKey;
  final bool isIndividual;
  final FocusNode consultedProductFocusNode;

  ConfirmQuantityButton({
    required this.consultedProductController,
    required this.countingCode,
    required this.productPackingCode,
    required this.isSubtract,
    required this.formKey,
    required this.isIndividual,
    required this.consultedProductFocusNode,
    Key? key,
  }) : super(key: key);

  @override
  State<ConfirmQuantityButton> createState() => _ConfirmQuantityButtonState();
}

class _ConfirmQuantityButtonState extends State<ConfirmQuantityButton> {
  bool isIndividual = false;

  alterFocusToConsultedProduct() {
    print('tá tentando alterar o foco');
    Future.delayed(Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(widget.consultedProductFocusNode);
    });
  }

  final AddQuantityController addQuantityController = AddQuantityController();
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
                ? 'Quantidade digitada: -${widget.consultedProductController.text}'
                : 'Quantidade digitada: ${widget.consultedProductController.text}',
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
                      addQuantityController.addQuantity(
                        isIndividual: isIndividual,
                        context: context,
                        countingCode: widget.countingCode,
                        quantity: widget.consultedProductController,
                        isSubtract: widget.isSubtract,
                        alterFocusToConsultedProduct:
                            alterFocusToConsultedProduct,
                      );
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

  @override
  Widget build(BuildContext context) {
    QuantityProvider quantityProvider = Provider.of(context, listen: true);
    final AddQuantityController addQuantityController = AddQuantityController();

    return ElevatedButton(
      onPressed: quantityProvider.isLoadingQuantity
          ? null
          : () async {
              bool isValid = widget.formKey.currentState!.validate();

              if (!isValid) {
                return;
              }

              if (double.tryParse(widget.consultedProductController.text
                      .replaceAll(RegExp(r','), '.'))! >=
                  1000) {
                await confirmQuantity(context: context);
              } else {
                addQuantityController.addQuantity(
                  isIndividual: isIndividual,
                  context: context,
                  countingCode: widget.countingCode,
                  quantity: widget.consultedProductController,
                  isSubtract: widget.isSubtract,
                  alterFocusToConsultedProduct: alterFocusToConsultedProduct,
                );
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
