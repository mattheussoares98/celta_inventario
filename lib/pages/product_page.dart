import 'package:celta_inventario/models/countings.dart';
import 'package:celta_inventario/models/enterprise.dart';
import 'package:celta_inventario/models/inventory.dart';
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
        print('scanbarcode$_scanBarcode');
      }
    });
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
            child: Form(
              key: _formKey,
              child: TextFormField(
                initialValue: _scanBarcode,
                onChanged: (value) => setState(() {
                  _scanBarcode = value;
                }),
                key: const ValueKey('key'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Digite o EAN ou PLU';
                  } else if (value.contains(',') ||
                      value.contains('.') ||
                      value.contains('-')) {
                    return 'A pesquisa deve conter somente números';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Digite o EAN ou PLU',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: productProvider.isChargingEan
                    ? null
                    : () async {
                        bool isValid = _formKey.currentState!.validate();
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
                onPressed: productProvider.isChargingEan
                    ? null
                    : () async {
                        bool isValid = _formKey.currentState!.validate();
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
                child: productProvider.isChargingPlu
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Consultar PLU'),
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
          // if (productProvider.productErrorMessage != '')
          //   Container(
          //     child: Text('Produto $_scanBarcode não encontrado'),
          //   ),
        ],
      ),
    );
  }
}
