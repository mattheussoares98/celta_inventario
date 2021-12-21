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

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of(context, listen: true);
    QuantityProvider quantityProvider = Provider.of(context, listen: true);

    String quantity = productProvider.products.isNotEmpty
        ? (productProvider.products[0].quantidadeInvContProEmb.toInt() + 1)
            .toString()
        : '';

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          Card(
            elevation: 10,
            color: Colors.lightBlue[100],
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Produto pesquisado',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Center(
                    child: Icon(
                      Icons.arrow_downward,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 15),
                  FittedBox(
                    child: Row(
                      children: [
                        const Text(
                          'Nome: ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          productProvider.products[0].productName,
                          style: const TextStyle(
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
                      const Text(
                        'PLU: ',
                        style: TextStyle(
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
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        'Quantidade contada: ',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        productProvider.products[0].quantidadeInvContProEmb
                            .toInt()
                            .toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Digite a quantidade';
                              } else if (value.contains(',') ||
                                  value.contains('.') ||
                                  value.contains('-') ||
                                  value.contains(' ')) {
                                return 'A pesquisa deve conter somente números';
                              }
                              return null;
                            },
                            initialValue: quantity,
                            onChanged: (value) => setState(() {
                              setState(() {
                                quantity = value;
                              });
                            }),
                            decoration: const InputDecoration(
                                labelText: 'Quantidade digitada',
                                labelStyle: TextStyle(
                                  color: Colors.blueAccent,
                                )),
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: quantityProvider.isLoadingEntryQuantity
                            ? null
                            : () {
                                quantityProvider.entryQuantity(
                                  countingCode: widget.countingCode,
                                  productPackingCode: productProvider
                                      .products[0].codigoInternoProEmb,
                                  quantity: int.parse(quantity),
                                );
                              },
                        child: const Text('Confirmar quantidade'),
                      ),
                    ],
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
