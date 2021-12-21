import 'package:celta_inventario/components/product_item.dart';
import 'package:celta_inventario/models/countings.dart';
import 'package:celta_inventario/provider/product_provider.dart';
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
        print('scanbarcode$_scanBarcode');
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Form(
                    key: _formEanOrPlu,
                    child: TextFormField(
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      maxLength: 13,
                      controller: _controllerProduct,
                      // initialValue: _scanBarcode,
                      onChanged: (value) => setState(() {
                        _scanBarcode = value;
                      }),

                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Digite o EAN ou o PLU';
                        } else if (value.contains(',') ||
                            value.contains('.') ||
                            value.contains('-')) {
                          return 'A pesquisa deve conter somente números';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Digite o EAN ou o PLU',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _controllerProduct.text = '';
                  },
                  child: const Text('   Limpar'),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: productProvider.isChargingEan
                    ? null
                    : () async {
                        bool isValid = _formEanOrPlu.currentState!.validate();
                        if (!isValid) return;

                        setState(() {
                          productProvider.isChargingEan = true;
                        });

                        try {
                          await productProvider.getProductByEan(
                            _scanBarcode.trim(),
                            productProvider.codigoInternoEmpresa!,
                            productProvider.codigoInternoInventario!,
                            countings.codigoInternoInvCont,
                          );
                        } catch (e) {
                          e;
                        } finally {
                          if (productProvider.productErrorMessage != '') {
                            showErrorMessage(
                                productProvider.productErrorMessage);
                          }
                        }
                      },
                child: productProvider.isChargingEan
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Consultar EAN'),
              ),
              TextButton(
                child: productProvider.isChargingPlu
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Consultar PLU'),
                onPressed: productProvider.isChargingEan
                    ? null
                    : () async {
                        bool isValid = _formEanOrPlu.currentState!.validate();
                        if (!isValid) return;

                        setState(() {
                          productProvider.isChargingPlu = true;
                        });

                        try {
                          await productProvider.getProductByPlu(
                            _scanBarcode.trim(),
                            productProvider.codigoInternoEmpresa!,
                            productProvider.codigoInternoInventario!,
                            countings.codigoInternoInvCont,
                          );
                        } catch (e) {
                          e;
                        } finally {
                          if (productProvider.productErrorMessage != '') {
                            showErrorMessage(
                                productProvider.productErrorMessage);
                          }
                        }
                      },
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: productProvider.isChargingEan
                        ? null
                        : () async {
                            try {
                              await scanBarcodeNormal();
                            } catch (e) {
                              e;
                            } finally {
                              final countings = ModalRoute.of(context)!
                                  .settings
                                  .arguments as Countings;
                              await productProvider.getProductByEan(
                                _scanBarcode,
                                productProvider.codigoInternoEmpresa!,
                                productProvider.codigoInternoInventario!,
                                countings.codigoInternoInvCont,
                              );

                              if (productProvider.productErrorMessage != '') {
                                showErrorMessage(
                                    productProvider.productErrorMessage);
                              }
                            }
                          },
                    child: Row(
                      children: const [
                        Text('Ler código'),
                        SizedBox(width: 5),
                        Icon(Icons.camera_alt),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (productProvider.products.isNotEmpty)
            ProductItem(
              countingCode: countings.codigoInternoInvCont,
              productPackingCode: 1,
            ),
        ],
      ),
    );
  }
}
