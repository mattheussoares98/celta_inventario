import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatefulWidget {
  final int countingCode;
  final int productPackingCode;
  const ProductItem({
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
    _confirmQuantity() {
      bool isValid = _formQuantity.currentState!.validate();
      if (!isValid || userQuantity == 0) {
        return;
      }
    }

    ProductProvider productProvider = Provider.of(context, listen: true);
    QuantityProvider quantityProvider = Provider.of(context, listen: true);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Card(
            elevation: 10,
            color: Theme.of(context).colorScheme.primary,
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
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Text(
                          productProvider.products[0].productName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
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
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(
                        productProvider.products[0].plu,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
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
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(
                        productProvider.products[0].quantidadeInvContProEmb
                            .toInt()
                            .toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Form(
                          key: _formQuantity,
                          child: TextFormField(
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
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
                            initialValue: '0',
                            onChanged: (value) {
                              if (value.isEmpty || value == '-') {
                                value = '0';
                              } else if (value.isNotEmpty &&
                                  !value.endsWith('-')) {
                                print('value = $value');
                                userQuantity = int.parse(value);
                              }
                              print('userQuantity $userQuantity');
                            },
                            decoration: InputDecoration(
                              labelText: 'Quantidade a ser somada',
                              errorStyle: TextStyle(
                                fontSize: 17,
                              ),
                              labelStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 25,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          onPressed: quantityProvider.isLoadingEntryQuantity
                              ? null
                              : () async {
                                  bool isValid =
                                      _formQuantity.currentState!.validate();

                                  if (!isValid || userQuantity == 0) {
                                    return;
                                  }

                                  setState(() {
                                    quantityProvider.isLoadingEntryQuantity =
                                        true;
                                  });

                                  try {
                                    print('no try $userQuantity');
                                    await quantityProvider.entryQuantity(
                                      countingCode: widget.countingCode,
                                      productPackingCode: productProvider
                                          .products[0].codigoInternoProEmb,
                                      quantity: userQuantity,
                                    );
                                  } catch (e) {
                                    e;
                                  } finally {
                                    if (quantityProvider.entryQuantityError !=
                                        '') {
                                      showErrorMessage(
                                          quantityProvider.entryQuantityError);
                                    }
                                    //aqui verifica se deu certo confirmar o envio da quantidade e caso dê certo, ele altera a quantidade contada
                                    if (quantityProvider.isConfirmed) {
                                      setState(() {
                                        productProvider.products[0]
                                                .quantidadeInvContProEmb =
                                            (productProvider.products[0]
                                                    .quantidadeInvContProEmb +
                                                userQuantity);
                                      });
                                    }
                                  }
                                  print('no final $userQuantity');
                                },
                          child: quantityProvider.isLoadingEntryQuantity
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SizedBox(height: 7),
                                    const Text(
                                      'confirmando...',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                    SizedBox(height: 7),
                                  ],
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Atualizar',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'quantidade',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  FittedBox(
                    child: Text(
                      'Para subtrair, digite uma quantidade negativa',
                      style: TextStyle(
                        fontSize: 200,
                        color: Colors.red[800],
                        fontStyle: FontStyle.italic,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 0.2,
                          )
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