import 'dart:ui';

import 'package:celta_inventario/components/product_item.dart';
import 'package:celta_inventario/models/countings.dart';
import 'package:celta_inventario/provider/login_provider.dart';
import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String _scanBarcode = '';

  final GlobalKey<FormState> _formEanOrPlu = GlobalKey<FormState>();

  Future<void> scanBarcodeNormal() async {
    setState(() {
      _scanBarcode = '';
    });
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      if (barcodeScanRes != '-1') {
        _scanBarcode = barcodeScanRes;
      }
    });

    _controllerProduct.text = _scanBarcode;
  }

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

  final TextEditingController _controllerProduct = TextEditingController();

  bool isLoadingEanAndPlu = false;
  bool isLoadingEan = false;

  @override
  Widget build(BuildContext context) {
    final countings = ModalRoute.of(context)!.settings.arguments as Countings;
    ProductProvider productProvider = Provider.of(context, listen: true);
    LoginProvider loginProvider = Provider.of(context);
    QuantityProvider quantityProvider = Provider.of(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            productProvider.clearProducts();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Produtos',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Form(
                      key: _formEanOrPlu,
                      child: TextFormField(
                        autofocus: true,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        maxLength: 13,
                        controller: _controllerProduct,
                        onChanged: (value) => setState(() {
                          _scanBarcode = value;
                        }),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Digite o EAN ou o PLU';
                          } else if (value.contains(',') ||
                              value.contains('.') ||
                              value.contains('-')) {
                            return 'Escreva somente números ou somente letras';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Digite o EAN ou o PLU',
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              style: BorderStyle.solid,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  child: isLoadingEanAndPlu || isLoadingEan
                      ? Row(
                          children: const [
                            Text(
                              'CONSULTANDO',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                              ),
                            ),
                            SizedBox(width: 5),
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Consultar produto',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                  onPressed: isLoadingEanAndPlu || isLoadingEan
                      ? null
                      : () async {
                          quantityProvider.isConfirmedQuantity = false;
                          bool isValid = _formEanOrPlu.currentState!.validate();
                          if (!isValid) return;

                          setState(() {
                            isLoadingEanAndPlu = true;
                          });

                          try {
                            await productProvider.getProductByEan(
                              ean: _scanBarcode,
                              enterpriseCode:
                                  productProvider.codigoInternoEmpresa!,
                              inventoryProcessCode:
                                  productProvider.codigoInternoInventario!,
                              inventoryCountingCode:
                                  countings.codigoInternoInvCont,
                              userIdentity: loginProvider.userIdentity,
                              baseUrl: loginProvider.userBaseUrl,
                            );

                            //só pesquisa o PLU se não encontrar pelo EAN
                            //sem esse if, de qualquer forma vai pesquisar o PLU
                            if (productProvider.products.isEmpty) {
                              await productProvider.getProductByPlu(
                                plu: _scanBarcode,
                                enterpriseCode:
                                    productProvider.codigoInternoEmpresa!,
                                inventoryProcessCode:
                                    productProvider.codigoInternoInventario!,
                                inventoryCountingCode:
                                    countings.codigoInternoInvCont,
                                userIdentity: loginProvider.userIdentity,
                                baseUrl: loginProvider.userBaseUrl,
                              );
                            }
                          } catch (e) {
                            e;
                          } finally {
                            if (productProvider.productErrorMessage != '') {
                              showErrorMessage(
                                  productProvider.productErrorMessage);
                            }
                          }
                          setState(() {
                            isLoadingEanAndPlu = false;
                          });
                        },
                ),
                ElevatedButton(
                  child: isLoadingEanAndPlu || isLoadingEan
                      ? Row(
                          children: const [
                            Text(
                              'CONSULTANDO',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                              ),
                            ),
                            SizedBox(width: 5),
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Text(
                              'Ler EAN',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.camera_alt,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ],
                        ),
                  onPressed: isLoadingEan || isLoadingEanAndPlu
                      ? null
                      : () async {
                          try {
                            await scanBarcodeNormal();
                            setState(() {
                              isLoadingEan = true;
                            });
                          } catch (e) {
                            e;
                          } finally {
                            final countings = ModalRoute.of(context)!
                                .settings
                                .arguments as Countings;
                            await productProvider.getProductByEan(
                              ean: _scanBarcode,
                              enterpriseCode:
                                  productProvider.codigoInternoEmpresa!,
                              inventoryProcessCode:
                                  productProvider.codigoInternoInventario!,
                              inventoryCountingCode:
                                  countings.codigoInternoInvCont,
                              userIdentity: loginProvider.userIdentity,
                              baseUrl: loginProvider.userBaseUrl,
                            );
                          }

                          setState(() {
                            isLoadingEan = false;
                          });
                          if (productProvider.productErrorMessage != '') {
                            showErrorMessage(
                                productProvider.productErrorMessage);
                          }
                        },
                ),
              ],
            ),
            if (productProvider.products.isNotEmpty)
              ProductItem(
                controllerProduct: _controllerProduct,
                countingCode: countings.codigoInternoInvCont,
                productPackingCode: countings.numeroContagemInvCont,
              ),
          ],
        ),
      ),
    );
  }
}
