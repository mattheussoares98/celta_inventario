import 'dart:ui';

import 'package:celta_inventario/components/product/consulted_product.dart';
import 'package:celta_inventario/models/countings.dart';
import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
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
  final _focusNodeConsultProduct = FocusNode();

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

    _controllerConsultProduct.text = _scanBarcode;
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

  final TextEditingController _controllerConsultProduct =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _focusNodeConsultProduct.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    QuantityProvider quantityProvider = Provider.of(context, listen: true);
    if(quantityProvider.isLoadingQuantity){
      FocusScope.of(context)
                            .requestFocus(_focusNodeConsultProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    final countings = ModalRoute.of(context)!.settings.arguments as Countings;
    ProductProvider productProvider = Provider.of(context, listen: true);
    QuantityProvider quantityProvider = Provider.of(context, listen: true);

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
            if (quantityProvider.isLoadingQuantity) {
              return;
            }
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
                          focusNode: _focusNodeConsultProduct,
                          enabled: isLoadingEanOrPlu ? false : true,
                          autofocus: true,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(14)
                          ],
                          controller: _controllerConsultProduct,
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
                    IconButton(
                      onPressed: () {
                        _controllerConsultProduct.clear();
                        FocusScope.of(context)
                            .requestFocus(_focusNodeConsultProduct);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: isLoadingEanOrPlu ||
                                quantityProvider.isLoadingQuantity
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FittedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 50),
                                        Text(
                                          quantityProvider.isLoadingQuantity
                                              ? 'AGUARDE...'
                                              : 'CONSULTANDO...',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'OpenSans',
                                            fontSize: 100,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 50),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: FittedBox(
                                  child: Container(
                                    height: 60,
                                    child: Row(
                                      children: [
                                        Text(
                                          'CONSULTAR OU ESCANEAR',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'OpenSans',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Icon(
                                          Icons.camera_alt_outlined,
                                          size: 40,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        onPressed: isLoadingEanOrPlu ||
                                quantityProvider.isLoadingQuantity
                            ? null
                            : () async {
                                if (_controllerConsultProduct.text.isEmpty) {
                                  try {
                                    await scanBarcodeNormal();
                                  } catch (e) {
                                    e;
                                  } finally {
                                    if (_controllerConsultProduct.text
                                        .isNotEmpty) await consultProduct();
                                  }
                                } else {
                                  consultProduct();
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              if (productProvider.products.isNotEmpty)
                ConsultedProduct(
                  controllerConsultProduct: _controllerConsultProduct,
                  countingCode: countings.codigoInternoInvCont,
                  productPackingCode: countings.numeroContagemInvCont,
                  focusNodeConsultProduct: _focusNodeConsultProduct,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
