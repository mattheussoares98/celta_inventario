import 'package:celta_inventario/provider/counting_provider.dart';
import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddOneQuantity extends StatefulWidget {
  final int? inventoryCountingCode;
  final int? countingCode;
  final int? productPackingCode;

  const AddOneQuantity({
    Key? key,
    required this.inventoryCountingCode,
    required this.countingCode,
    required this.productPackingCode,
  }) : super(key: key);

  @override
  _AddOneQuantityState createState() => _AddOneQuantityState();
}

class _AddOneQuantityState extends State<AddOneQuantity> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode _addQuantityFocusNode = FocusNode();

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

  final TextEditingController _addOneQuantityController =
      TextEditingController();

  Future<void> consultProductAndAddOneQuantity() async {
    ProductProvider productProvider = Provider.of(context, listen: false);
    QuantityProvider quantityProvider = Provider.of(context, listen: false);
    setState(() {
      productProvider.isLoadingEanOrPlu = true;
    });

    await productProvider.getProductByEan(
      ean: _addOneQuantityController.text,
      enterpriseCode: productProvider.codigoInternoEmpresa!,
      inventoryProcessCode: productProvider.codigoInternoInventario!,
      inventoryCountingCode: widget.inventoryCountingCode,
      userIdentity: UserIdentity.identity,
      baseUrl: BaseUrl.url,
    );

    //só pesquisa o PLU se não encontrar pelo EAN
    //sem esse if, de qualquer forma vai pesquisar o PLU
    if (productProvider.products.isEmpty) {
      await productProvider.getProductByPlu(
        plu: _addOneQuantityController.text,
        enterpriseCode: productProvider.codigoInternoEmpresa!,
        inventoryProcessCode: productProvider.codigoInternoInventario!,
        inventoryCountingCode: widget.inventoryCountingCode,
        userIdentity: UserIdentity.identity,
        baseUrl: BaseUrl.url,
      );
    }

    if (productProvider.products.isNotEmpty) {
      print('tentando confirmar a quantidade');
      await quantityProvider.entryQuantity(
        countingCode: widget.countingCode,
        productPackingCode: productProvider.products[0].codigoInternoProEmb,
        quantity: '1',
        userIdentity: UserIdentity.identity,
        baseUrl: BaseUrl.url,
        isSubtract: false,
      );

      if (quantityProvider.isConfirmedQuantity) {
        setState(() {
          productProvider.products[0].quantidadeInvContProEmb =
              productProvider.products[0].quantidadeInvContProEmb +
                  double.tryParse('1');
        });
      }
    }

    setState(() {
      productProvider.isLoadingEanOrPlu = false;
    });

    if (productProvider.errorMessage != '') {
      showErrorMessage(productProvider.errorMessage);
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      FocusScope.of(context).requestFocus(_addQuantityFocusNode);
    });
    _addOneQuantityController.clear();
  }

  insertingOneUnity(String message) {
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Text(
              message,
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(width: 10),
            Container(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _addQuantityFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of(context, listen: true);
    QuantityProvider quantityProvider = Provider.of(context, listen: true);

    validateFormKey() {
      bool isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          if (quantityProvider.isLoadingQuantity)
            insertingOneUnity('Inserindo uma unidade...'),
          Container(
            height: 60,
            child: Row(
              children: [
                Flexible(
                  flex: 11,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      autofocus: true,
                      focusNode: _addQuantityFocusNode,
                      enabled: productProvider.isLoadingEanOrPlu ||
                              quantityProvider.isLoadingQuantity
                          ? false
                          : true,
                      controller: _addOneQuantityController,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        labelText: 'Pesquisar e inserir uma unidade',
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
                        if (_addOneQuantityController.text.isEmpty) {
                          return;
                        }
                        await consultProductAndAddOneQuantity();
                      },
                    ),
                  ),
                ),
                SizedBox(width: 3),
                Flexible(
                  flex: 4,
                  child: Container(
                    height: 500,
                    child: ElevatedButton(
                      onPressed: productProvider.isLoadingEanOrPlu ||
                              quantityProvider.isLoadingQuantity
                          ? null
                          : () async {
                              await consultProductAndAddOneQuantity();
                            },
                      child: FittedBox(
                        child: Text(
                          productProvider.isLoadingEanOrPlu ||
                                  quantityProvider.isLoadingQuantity
                              ? 'AGUARDE...'
                              : 'CONFIRMAR',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
