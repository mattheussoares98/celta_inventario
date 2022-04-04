import 'package:celta_inventario/pages/product_page/anull_quantity_bottom.dart';
import 'package:celta_inventario/pages/product_page/confirm_quantity_button.dart';
import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ConsultedProductWidget extends StatefulWidget {
  final int countingCode;
  final int productPackingCode;
  final bool isIndividual;
  final bool? isLoadingEanOrPlu;
  ConsultedProductWidget({
    Key? key,
    required this.countingCode,
    required this.productPackingCode,
    required this.isIndividual,
    this.isLoadingEanOrPlu,
  }) : super(key: key);

  @override
  State<ConsultedProductWidget> createState() => ConsultedProductWidgetState();
}

class ConsultedProductWidgetState extends State<ConsultedProductWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isIndividual = false;

  static final TextEditingController _consultedProductController =
      TextEditingController();

  final _consultedProductFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _consultedProductFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of(context, listen: true);
    QuantityProvider quantityProvider = Provider.of(context, listen: true);

    setState(() {
      isIndividual = widget.isIndividual;
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 8),
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
              const SizedBox(height: 8),
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
                    child: FittedBox(
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
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                  )
                ],
              ),
              if (quantityProvider.lastQuantityAdded != '')
                const SizedBox(height: 3),
              if (quantityProvider.lastQuantityAdded != '')
                FittedBox(
                  child: Text(
                    quantityProvider.subtractedQuantity &&
                            quantityProvider.isConfirmedQuantity
                        ? 'Última quantidade adicionada:  -${quantityProvider.lastQuantityAdded} '
                        : 'Última quantidade adicionada:  ${quantityProvider.lastQuantityAdded} ',
                    style: TextStyle(
                      fontSize: 100,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'BebasNeue',
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1,
                      wordSpacing: 4,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              const SizedBox(height: 8),
              if (!widget.isIndividual)
                Column(
                  children: [
                    Row(
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
                                controller: _consultedProductController,
                                focusNode: _consultedProductFocusNode,
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
                                  } else if (value == '0' ||
                                      value == '0.' ||
                                      value == '0,') {
                                    return 'Digite uma quantidade';
                                  } else if (value.contains('..')) {
                                    return 'Carácter inválido';
                                  } else if (value.contains(',,')) {
                                    return 'Carácter inválido';
                                  } else if (value.contains(',.')) {
                                    return 'Carácter inválido';
                                  } else if (value.contains('.,')) {
                                    return 'Carácter inválido';
                                  } else if (value.contains('-')) {
                                    return 'Carácter inválido';
                                  } else if (value.contains(' ')) {
                                    return 'Carácter inválido';
                                  }
                                  return null;
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
                              countingCode: widget.countingCode,
                              productPackingCode: productProvider
                                  .products[0].codigoInternoProEmb,
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              height: 70,
                              width: double.infinity,
                              child: ConfirmQuantityButton(
                                isIndividual: isIndividual,
                                consultedProductController:
                                    _consultedProductController,
                                countingCode: widget.countingCode,
                                productPackingCode: productProvider
                                    .products[0].codigoInternoProEmb,
                                isSubtract: false,
                                formKey: _formKey,
                                consultedProductFocusNode:
                                    _consultedProductFocusNode,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 70,
                              child: ConfirmQuantityButton(
                                isIndividual: isIndividual,
                                consultedProductController:
                                    _consultedProductController,
                                countingCode: widget.countingCode,
                                productPackingCode: productProvider
                                    .products[0].codigoInternoProEmb,
                                isSubtract: true,
                                formKey: _formKey,
                                consultedProductFocusNode:
                                    _consultedProductFocusNode,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}