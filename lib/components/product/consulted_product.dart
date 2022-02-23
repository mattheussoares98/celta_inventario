import 'dart:async';
import 'package:celta_inventario/components/product/anull_quantity_bottom.dart';
import 'package:celta_inventario/components/product/confirm_quantity_button.dart';
import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ConsultedProduct extends StatefulWidget {
  final int countingCode;
  final int productPackingCode;
  final FocusNode focusNodeConsultProduct;
  ConsultedProduct({
    Key? key,
    required this.countingCode,
    required this.productPackingCode,
    required this.focusNodeConsultProduct,
  }) : super(key: key);

  @override
  State<ConsultedProduct> createState() => _ConsultedProductState();
}

class _ConsultedProductState extends State<ConsultedProduct> {
  TextEditingController controllerConsultedProduct = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  showErrorMessage(String error) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 7),
        backgroundColor: Colors.red,
        content: Text(error),
      ),
    );
  }

  final _quantityFocusNode = FocusNode();

  String lastQuantityConfirmed = '';

  @override //essa função serve para liberar qualquer tipo de memória que esteja sendo utilizado por esses FocusNode e Listner (precisou ser criado pra conseguir carregar a imagem quando trocasse o foco)
  void dispose() {
    super.dispose();
    _quantityFocusNode.dispose();
    controllerConsultedProduct.dispose();
  }

  updateLastQuantity() {
    setState(() {
      lastQuantityConfirmed = controllerConsultedProduct.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of(context, listen: true);
    QuantityProvider quantityProvider = Provider.of(context, listen: true);

    void alterFocusToQuantity() {
      if (!quantityProvider.isLoadingQuantity) {
//se não coloca isso em um Future, pelo jeito tenta mudar o foco antes do formfield
//estar habilitado novamente. Depois de colocar em um Future, funcionou corretamente
//a alternação de foco
        Future.delayed(const Duration(milliseconds: 100), () {
          FocusScope.of(context).requestFocus(_quantityFocusNode);
        });
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                width: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 10,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  FittedBox(
                    child: Row(
                      children: [
                        Text(
                          productProvider.products[0].productName.substring(9),
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'PLU: ',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        productProvider.products[0].plu,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //precisei colocar o flexible porque pelo fittedbox não estava funcionando como queria
                      Flexible(
                        flex: 20,
                        child: Text(
                          'Quantidade contada: ',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Flexible(
                        flex: 15,
                        child: Text(
                          productProvider.products[0].quantidadeInvContProEmb
                                      .toString() ==
                                  'null'
                              ? 'sem contagem'
                              : productProvider
                                  .products[0].quantidadeInvContProEmb
                                  .toDouble()
                                  .toString(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Container(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                autofocus: true,
                                enabled: quantityProvider.isLoadingQuantity
                                    ? false
                                    : true,
                                controller: controllerConsultedProduct,
                                focusNode: _quantityFocusNode,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(7)
                                ],
                                onChanged: (value) {
                                  if (value.isEmpty || value == '-') {
                                    value = '0';
                                  }
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Digite uma quantidade';
                                  } else if (value.contains('-')) {
                                    return 'Valor incorreto';
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: 'Digite a quantidade aqui',
                                  errorStyle: TextStyle(
                                    fontSize: 17,
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      width: 2,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      width: 2,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: AnullQuantityBottom(
                              showErrorMessage: showErrorMessage,
                              countingCode: widget.countingCode,
                              productPackingCode: productProvider
                                  .products[0].codigoInternoProEmb,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            child: ConfirmQuantityButton(
                              controllerConsultedProduct:
                                  controllerConsultedProduct,
                              showErrorMessage: showErrorMessage,
                              countingCode: widget.countingCode,
                              productPackingCode: productProvider
                                  .products[0].codigoInternoProEmb,
                              isSubtract: false,
                              formKey: _formKey,
                              alterFocusToQuantity: alterFocusToQuantity,
                              updateLastQuantity: updateLastQuantity,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          flex: 1,
                          child: Container(
                            height: 60,
                            child: ConfirmQuantityButton(
                              controllerConsultedProduct:
                                  controllerConsultedProduct,
                              showErrorMessage: showErrorMessage,
                              countingCode: widget.countingCode,
                              productPackingCode: productProvider
                                  .products[0].codigoInternoProEmb,
                              isSubtract: true,
                              formKey: _formKey,
                              alterFocusToQuantity: alterFocusToQuantity,
                              updateLastQuantity: updateLastQuantity,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (lastQuantityConfirmed != '')
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Última quantidade digitada: ${quantityProvider.subtractedQuantity ? '-$lastQuantityConfirmed' : lastQuantityConfirmed}',
                              style: TextStyle(
                                fontSize: 500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
