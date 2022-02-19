import 'dart:ui';

import 'package:celta_inventario/components/product/consulted_product.dart';
import 'package:celta_inventario/models/countings.dart';
import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/user_identity.dart';
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
  bool isLoadingEanOrPlu = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    final countings = ModalRoute.of(context)!.settings.arguments as Countings;
    ProductProvider productProvider = Provider.of(context, listen: true);

    Future<void> consultProduct() async {
      setState(() {
        isLoadingEanOrPlu = true;
      });

      await productProvider.getProductByEan(
        ean: _scanBarcode,
        enterpriseCode: productProvider.codigoInternoEmpresa!,
        inventoryProcessCode: productProvider.codigoInternoInventario!,
        inventoryCountingCode: countings.codigoInternoInvCont,
        userIdentity: UserIdentity.identity,
        baseUrl: BaseUrl.url,
      );

      //só pesquisa o PLU se não encontrar pelo EAN
      //sem esse if, de qualquer forma vai pesquisar o PLU
      if (productProvider.products.isEmpty) {
        await productProvider.getProductByPlu(
          plu: _scanBarcode,
          enterpriseCode: productProvider.codigoInternoEmpresa!,
          inventoryProcessCode: productProvider.codigoInternoInventario!,
          inventoryCountingCode: countings.codigoInternoInvCont,
          userIdentity: UserIdentity.identity,
          baseUrl: BaseUrl.url,
        );
      }

      setState(() {
        isLoadingEanOrPlu = false;
      });

      if (productProvider.productErrorMessage != '') {
        showErrorMessage(productProvider.productErrorMessage);
      }
    }

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          autofocus: true,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(14)
                          ],
                          controller: _controllerProduct,
                          onChanged: (value) => setState(() {
                            _scanBarcode = value;
                          }),
                          validator: (value) {
                            if (value!.contains(',') ||
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
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      child: isLoadingEanOrPlu
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'CONSULTANDO...',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'OpenSans',
                                          fontSize: 100,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      SizedBox(
                                        height: 60,
                                        width: 60,
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FittedBox(
                                child: Text(
                                  'CONSULTAR PRODUTO',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans',
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 500,
                                  ),
                                ),
                              ),
                            ),
                      onPressed: isLoadingEanOrPlu
                          ? null
                          : () async {
                              if (_controllerProduct.text.isEmpty) {
                                try {
                                  await scanBarcodeNormal();
                                  setState(() {
                                    isLoadingEanOrPlu = true;
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
                                    inventoryProcessCode: productProvider
                                        .codigoInternoInventario!,
                                    inventoryCountingCode:
                                        countings.codigoInternoInvCont,
                                    userIdentity: UserIdentity.identity,
                                    baseUrl: BaseUrl.url,
                                  );
                                  setState(() {
                                    isLoadingEanOrPlu = false;
                                  });
                                }
                              } else {
                                consultProduct();
                              }
                            },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (productProvider.products.isNotEmpty)
                ConsultedProduct(
                  controllerProduct: _controllerProduct,
                  countingCode: countings.codigoInternoInvCont,
                  productPackingCode: countings.numeroContagemInvCont,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
