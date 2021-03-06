import 'package:celta_inventario/components/personalized_card.dart';
import 'package:celta_inventario/pages/product_page/anull_quantity_button.dart';
import 'package:celta_inventario/pages/product_page/confirm_quantity_button.dart';
import 'package:celta_inventario/pages/product_page/product_provider.dart';
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

    double? lastQuantityAdded =
        double.tryParse(quantityProvider.lastQuantityAdded);

    dynamic atualQuantity = productProvider.products[0].quantidadeInvContProEmb;

    return PersonalizedCard().personalizedCard(
      context: context,
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
                  const Text(
                    'Produto: ',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  //26
                  Text(
                    productProvider.products[0].productName.length > 26
                        //se o nome do produto tiver mais de 26 caracteres, vai ficar ruim a exibi????o somente em uma linha, a?? ele quebra a linha no 26?? caracter
                        ? productProvider.products[0].productName.replaceRange(
                                26,
                                productProvider.products[0].productName.length,
                                '\n') +
                            productProvider.products[0].productName
                                .substring(26)
                                .replaceFirst(
                                  RegExp(r'\('),
                                  '\n\(',
                                )
                        : productProvider.products[0].productName,
                    style: const TextStyle(
                      fontSize: 20,
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
                const Text(
                  'PLU: ',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  productProvider.products[0].plu,
                  style: const TextStyle(
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
                //precisei colocar o flexible porque pelo fittedbox n??o estava funcionando como queria
                const Flexible(
                  flex: 20,
                  child: Text(
                    'Quantidade contada: ',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Flexible(
                  flex: 15,
                  child: FittedBox(
                    child: Text(
                      atualQuantity == double
                          ? double.tryParse(atualQuantity.toString())!
                              .toStringAsFixed(3)
                              .replaceAll(RegExp(r'\.'), ',')
                          : atualQuantity.toString() == 'null'
                              ? 'Sem contagem'
                              : double.tryParse(atualQuantity.toString())!
                                  .toStringAsFixed(3)
                                  .replaceAll(RegExp(r'\.'), ','),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
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
                  quantityProvider.isSubtract &&
                          quantityProvider.isConfirmedQuantity
                      ? '??ltima quantidade adicionada:  -${lastQuantityAdded!.toStringAsFixed(3).replaceAll(RegExp(r'\.'), ',')} '
                      : '??ltima quantidade adicionada:  ${lastQuantityAdded!.toStringAsFixed(3).replaceAll(RegExp(r'\.'), ',')} ',
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
                                LengthLimitingTextInputFormatter(10)
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
                                  return 'Car??cter inv??lido';
                                } else if (value.contains(',,')) {
                                  return 'Car??cter inv??lido';
                                } else if (value.contains(',.')) {
                                  return 'Car??cter inv??lido';
                                } else if (value.contains('.,')) {
                                  return 'Car??cter inv??lido';
                                } else if (value.contains('-')) {
                                  return 'Car??cter inv??lido';
                                } else if (value.contains(' ')) {
                                  return 'Car??cter inv??lido';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Digite a quantidade aqui',
                                errorStyle: const TextStyle(
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
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              style: const TextStyle(
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
                          child: AnullQuantityButton(
                            countingCode: widget.countingCode,
                            productPackingCode:
                                productProvider.products[0].codigoInternoProEmb,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        flex: 5,
                        child: ConfirmQuantityButton(
                          isIndividual: isIndividual,
                          consultedProductController:
                              _consultedProductController,
                          countingCode: widget.countingCode,
                          isSubtract: false,
                          formKey: _formKey,
                          consultedProductFocusNode: _consultedProductFocusNode,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        flex: 2,
                        child: ConfirmQuantityButton(
                          isIndividual: isIndividual,
                          consultedProductController:
                              _consultedProductController,
                          countingCode: widget.countingCode,
                          isSubtract: true,
                          formKey: _formKey,
                          consultedProductFocusNode: _consultedProductFocusNode,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
