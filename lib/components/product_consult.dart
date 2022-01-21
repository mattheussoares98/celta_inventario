import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ProductConsult extends StatefulWidget {
  const ProductConsult({Key? key}) : super(key: key);

  @override
  State<ProductConsult> createState() => _ProductConsultState();
}

class _ProductConsultState extends State<ProductConsult> {
  final TextEditingController _controllerProduct = TextEditingController();

  String _scanBarcode = '';

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

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // autofocus: true,
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
      decoration: const InputDecoration(
        labelText: 'Digite o EAN ou o PLU',
        labelStyle: TextStyle(
          color: Colors.black,
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
