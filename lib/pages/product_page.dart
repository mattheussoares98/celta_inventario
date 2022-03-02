import 'dart:async';
import 'package:celta_inventario/components/product/consulted_product.dart';
import 'package:celta_inventario/controller/productPage/add_quantity_controller.dart';
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
  final _consultProductFocusNode = FocusNode();
  final _consultedProductFocusNode = FocusNode();
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

    _consultProductController.text = _scanBarcode;
  }

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

  final TextEditingController _consultProductController =
      TextEditingController();

  final TextEditingController _consultedProductController =
      TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _consultProductFocusNode.dispose();
    _consultProductController.dispose();
    _consultedProductFocusNode.dispose();
  }

  bool isIndividual = false;

  alterFocusToConsultProduct() {
    Future.delayed(Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_consultProductFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final countings = ModalRoute.of(context)!.settings.arguments as Countings;
    ProductProvider productProvider = Provider.of(context, listen: true);
    QuantityProvider quantityProvider = Provider.of(context, listen: true);
    final AddQuantityController addQuantityController = AddQuantityController();

    Future<void> consultAndAddProduct() async {
      setState(() {
        isLoadingEanOrPlu = true;
        quantityProvider.lastQuantityAdded = '';
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
        alterFocusToConsultProduct();
      }

      if (productProvider.productErrorMessage == '' && isIndividual) {
        await addQuantityController.addQuantity(
          isIndividual: true,
          context: context,
          countingCode: countings.codigoInternoInvCont,
          quantity: '1',
          isSubtract: false,
          showErrorMessage: showErrorMessage,
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //     if (quantityProvider.isLoadingQuantity) {
        //       return;
        //     }
        //     productProvider.clearProducts();
        //   },
        //   icon: Icon(Icons.arrow_back),
        // ),
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
                          onFieldSubmitted: (value) async {
                            await consultAndAddProduct();
                            alterFocusToConsultProduct();
                            _consultProductController.clear();
                          },
                          focusNode: _consultProductFocusNode,
                          enabled: isLoadingEanOrPlu ||
                                  quantityProvider.isLoadingQuantity
                              ? false
                              : true,
                          autofocus: true,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(14)
                          ],
                          controller: _consultProductController,
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
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                                width: 2,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
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
                      onPressed: isLoadingEanOrPlu
                          ? null
                          : () {
                              _consultProductController.clear();
                              alterFocusToConsultProduct();
                            },
                      icon: Icon(
                        Icons.delete,
                        color: isLoadingEanOrPlu ? null : Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: isLoadingEanOrPlu ||
                                quantityProvider.isLoadingQuantity
                            ? Container(
                                height: 70,
                                child: FittedBox(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 50),
                                      Text(
                                        quantityProvider.isLoadingQuantity
                                            ? 'ADICIONANDO QUANTIDADE...'
                                            : 'CONSULTANDO O PRODUTO...',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'OpenSans',
                                          fontSize: 100,
                                        ),
                                      ),
                                      SizedBox(width: 30),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 70),
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 50),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                height: 70,
                                child: FittedBox(
                                  child: Row(
                                    children: [
                                      Text(
                                        isIndividual
                                            ? 'CONSULTAR E INSERIR UNIDADE'
                                            : 'CONSULTAR OU ESCANEAR',
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
                                        !isIndividual
                                            ? Icons.camera_alt_outlined
                                            : Icons.add,
                                        size: 40,
                                      ),
                                      if (isIndividual)
                                        Text(
                                          '1',
                                          style: TextStyle(
                                            fontSize: 40,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                        onPressed: isLoadingEanOrPlu ||
                                quantityProvider.isLoadingQuantity
                            ? null
                            : () async {
                                if (_consultProductController.text.isEmpty) {
                                  try {
                                    await scanBarcodeNormal();
                                  } catch (e) {
                                    e;
                                  } finally {
                                    //se ler algum código, vai consultar o produto
                                    if (_consultProductController
                                        .text.isNotEmpty) {
                                      await consultAndAddProduct();
                                    }
                                  }
                                } else {
                                  await consultAndAddProduct();
                                }

                                if (productProvider.products.isNotEmpty &&
                                    isIndividual) {
                                  _consultProductController.clear();
                                  alterFocusToConsultProduct();
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 4),
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Inserir produto individualmente',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(width: 20),
                      Switch(
                          value: isIndividual,
                          onChanged: isLoadingEanOrPlu ||
                                  quantityProvider.isLoadingQuantity
                              ? null
                              : (value) {
                                  setState(() {
                                    isIndividual = value;
                                  });
                                  if (isIndividual) {
                                    alterFocusToConsultProduct();
                                  }
                                }),
                    ],
                  ),
                ),
              ),
              // const SizedBox(height: 8),
              if (productProvider.products.isNotEmpty)
                ConsultedProduct(
                  consultedProductController: _consultedProductController,
                  isIndividual: isIndividual,
                  countingCode: countings.codigoInternoInvCont,
                  productPackingCode: countings.numeroContagemInvCont,
                  consultedProductFocusNode: _consultedProductFocusNode,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
