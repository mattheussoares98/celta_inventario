import 'dart:async';
import 'package:celta_inventario/pages/product_page/consult_product_widget.dart';
import 'package:celta_inventario/pages/product_page/consulted_product_widget.dart';
import 'package:celta_inventario/models/countings.dart';
import 'package:celta_inventario/pages/product_page/consult_product_controller.dart';
import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _consultProductFocusNode = FocusNode();

  bool isIndividual = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static final TextEditingController _consultProductController =
      TextEditingController();

  // static String _scanBarcode = '';

  @override
  void dispose() {
    super.dispose();
    _consultProductFocusNode.dispose();
  }

  alterFocusToConsultProduct() {
    ConsultProductController.instance.alterFocusToConsultProduct(
      consultProductFocusNode: _consultProductFocusNode,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of(context, listen: true);
    QuantityProvider quantityProvider = Provider.of(context, listen: true);
    final countings = ModalRoute.of(context)!.settings.arguments as Countings;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Produtos',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ConsultProductWidget(
                formKey: _formKey,
                isIndividual: isIndividual,
                consultProductFocusNode: _consultProductFocusNode,
                consultProductController: _consultProductController,
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
                        onChanged: productProvider.isLodingEanOrPlu ||
                                quantityProvider.isLoadingQuantity
                            ? null
                            : (value) {
                                setState(() {
                                  isIndividual = value;
                                });
                                if (isIndividual) {
                                  alterFocusToConsultProduct();
                                }
                              },
                      ),
                    ],
                  ),
                ),
              ),
              if (productProvider.products.isNotEmpty)
                ConsultedProductWidget(
                  isIndividual: isIndividual,
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
