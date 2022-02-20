import 'package:celta_inventario/components/product/anull_quantity_bottom.dart';
import 'package:celta_inventario/components/product/add_quantity_button.dart';
import 'package:celta_inventario/components/product/subtract_quantity_button.dart';
import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:celta_inventario/utils/colors_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ConsultedProduct extends StatefulWidget {
  final int countingCode;
  final int productPackingCode;
  final TextEditingController controllerProduct;
  ConsultedProduct({
    Key? key,
    required this.controllerProduct,
    required this.countingCode,
    required this.productPackingCode,
  }) : super(key: key);

  @override
  State<ConsultedProduct> createState() => _ConsultedProductState();
}

String userQuantity = '0';

class _ConsultedProductState extends State<ConsultedProduct> {
  final TextEditingController _controller = TextEditingController();

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ProductProvider productProvider = Provider.of(context, listen: true);
    if (productProvider.products.isNotEmpty) {
      FocusScope.of(context).requestFocus(_quantityFocusNode);
    }
  }

  @override //essa função serve para liberar qualquer tipo de memória que esteja sendo utilizado por esses FocusNode e Listner (precisou ser criado pra conseguir carregar a imagem quando trocasse o foco)
  void dispose() {
    super.dispose();
    _quantityFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of(context, listen: true);
    QuantityProvider quantityProvider = Provider.of(context, listen: true);

    return Column(
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
                FittedBox(
                  child: Container(
                    width: 400,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Quantidade contada: ',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          productProvider.products[0].quantidadeInvContProEmb
                                      .toString() ==
                                  'null'
                              ? 'sem contagem'
                              : productProvider
                                  .products[0].quantidadeInvContProEmb
                                  .toDouble()
                                  .toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Container(
                          child: TextField(
                            controller: _controller,
                            focusNode: _quantityFocusNode,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(5)
                            ],
                            enabled: quantityProvider.isLoadingQuantity
                                ? false
                                : true,
                            onChanged: (value) {
                              if (value.isEmpty || value == '-') {
                                value = '0';
                              } else if (value.isNotEmpty &&
                                  !value.endsWith('-')) {
                                //se não colocar no setState, não consegue
                                //perceber que veio a informação da outra tela
                                //e por isso não altera o valor
                                setState(() {
                                  userQuantity = value;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Digite a quantidade aqui',
                              errorStyle: TextStyle(
                                fontSize: 17,
                              ),
                              disabledBorder: OutlineInputBorder(
                                // borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  width: 2,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              border: OutlineInputBorder(
                                // borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  width: 2,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              labelStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        flex: 1,
                        child: Container(
                          child: AnullQuantityBottom(
                            controllerProduct: widget.controllerProduct,
                            showErrorMessage: showErrorMessage,
                            countingCode: widget.countingCode,
                            productPackingCode:
                                productProvider.products[0].codigoInternoProEmb,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // FittedBox(
                //   child: Text(
                //     '*Para subtrair, digite uma quantidade negativa',
                //     style: TextStyle(
                //       fontSize: 200,
                //       color: Colors.red,
                //       fontStyle: FontStyle.italic,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                flex: 3,
                child: Container(
                  height: 70,
                  width: double.infinity,
                  child: AddQuantityButton(
                    controllerProduct: widget.controllerProduct,
                    userQuantity: userQuantity,
                    showErrorMessage: showErrorMessage,
                    countingCode: widget.countingCode,
                    productPackingCode:
                        productProvider.products[0].codigoInternoProEmb,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                flex: 1,
                child: Container(
                  height: 70,
                  child: SubtractQuantityButton(
                    controllerProduct: widget.controllerProduct,
                    userQuantity: userQuantity,
                    showErrorMessage: showErrorMessage,
                    countingCode: widget.countingCode,
                    productPackingCode:
                        productProvider.products[0].codigoInternoProEmb,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
