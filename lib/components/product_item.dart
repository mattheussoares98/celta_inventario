import 'package:celta_inventario/components/anull_quantity_bottom.dart';
import 'package:celta_inventario/components/confirm_quantity_bottom.dart';
import 'package:celta_inventario/provider/login_provider.dart';
import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatefulWidget {
  final int countingCode;
  final int productPackingCode;
  ProductItem({
    Key? key,
    required this.countingCode,
    required this.productPackingCode,
  }) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  final GlobalKey<FormState> _formQuantity = GlobalKey<FormState>();

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

  int userQuantity = 0;

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of(context, listen: true);
    QuantityProvider quantityProvider = Provider.of(context, listen: true);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          const SizedBox(height: 5),
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
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  FittedBox(
                    child: Row(
                      children: [
                        Text(
                          'Nome: ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          productProvider.products[0].productName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
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
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Quantidade contada: ',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        productProvider.products[0].quantidadeInvContProEmb
                                    .toString() ==
                                'null'
                            ? 'null'
                            : productProvider
                                .products[0].quantidadeInvContProEmb
                                .toInt()
                                .toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  Form(
                    key: _formQuantity,
                    child: TextFormField(
                      enabled:
                          quantityProvider.isLoadingQuantity ? false : true,
                      autofocus: true,
                      validator: (value) {
                        if (value!.contains(',') ||
                            value.contains('.') ||
                            value.contains(' ')) {
                          return 'Caracter inválido';
                        } else if (value == '-') {
                          return 'Digite a quantidade';
                        } else if (value.isEmpty) {
                          return 'Digite a quantidade';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.isEmpty || value == '-') {
                          value = '0';
                        } else if (value.isNotEmpty && !value.endsWith('-')) {
                          setState(() {
                            //se não colocar no setState, não consegue perceber que veio a informação da outra tela e por isso não altera o valor
                            userQuantity = int.parse(value);
                          });
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Digite a quantidade aqui',
                        errorStyle: TextStyle(
                          fontSize: 17,
                        ),
                        labelStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.red,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 25,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ConfirmQuantityBottom(
                        userQuantity: userQuantity,
                        showErrorMessage: showErrorMessage,
                        countingCode: widget.countingCode,
                        productPackingCode:
                            productProvider.products[0].codigoInternoProEmb,
                        formQuantity: _formQuantity,
                      ),
                      AnullQuantityBottom(
                        showErrorMessage: showErrorMessage,
                        countingCode: widget.countingCode,
                        productPackingCode:
                            productProvider.products[0].codigoInternoProEmb,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  FittedBox(
                    child: Text(
                      '*Para subtrair, digite uma quantidade negativa',
                      style: TextStyle(
                        fontSize: 200,
                        color: Colors.red,
                        fontStyle: FontStyle.italic,
                        // shadows: [
                        //   Shadow(
                        //     color: Colors.black,
                        //     blurRadius: 0.2,
                        //   )
                        // ],
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
