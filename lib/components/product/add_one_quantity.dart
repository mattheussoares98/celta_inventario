import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddOneQuantity extends StatefulWidget {
  final String? ean;
  final int? enterpriseCode;
  final int? inventoryProcessCode;
  final int? inventoryCountingCode;
  final String? userIdentity;
  final String? baseUrl;

  const AddOneQuantity({
    Key? key,
    required this.ean,
    required this.enterpriseCode,
    required this.inventoryProcessCode,
    required this.inventoryCountingCode,
    required this.userIdentity,
    required this.baseUrl,
  }) : super(key: key);

  @override
  _AddOneQuantityState createState() => _AddOneQuantityState();
}

class _AddOneQuantityState extends State<AddOneQuantity> {
  showErrorMessage(String error) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red,
        content: Text(error),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of(context, listen: true);
    QuantityProvider quantityProvider = Provider.of(context, listen: true);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              // label: Text('teste'),
              labelText: 'Pesquisar produto e inserir uma unidade',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                  width: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            keyboardType: TextInputType.number,
            onFieldSubmitted: (value) async {
              productProvider.isLoadingEanOrPlu = true;
              try {
                await productProvider.getProductByEan(
                    ean: widget.ean,
                    enterpriseCode: widget.enterpriseCode,
                    inventoryProcessCode: widget.inventoryProcessCode,
                    inventoryCountingCode: widget.inventoryCountingCode,
                    userIdentity: widget.userIdentity,
                    baseUrl: widget.baseUrl);

                print('terminou a consulta do EAN');
                if (productProvider.products.isEmpty) {
                  productProvider.isLoadingEanOrPlu = true;
                  print('começou a consulta do PLU');
                  await productProvider.getProductByPlu(
                      plu: widget.ean,
                      enterpriseCode: widget.enterpriseCode,
                      inventoryProcessCode: widget.inventoryProcessCode,
                      inventoryCountingCode: widget.inventoryCountingCode,
                      userIdentity: widget.userIdentity,
                      baseUrl: widget.baseUrl);
                }
              } catch (e) {}
              if (productProvider.errorMessage != '') {
                showErrorMessage(productProvider.errorMessage);
              }
              productProvider.isLoadingEanOrPlu = false;
            },
          ),
        ],
      ),
    );
  }
}
