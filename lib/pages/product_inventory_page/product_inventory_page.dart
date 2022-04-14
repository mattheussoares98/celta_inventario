import 'package:celta_inventario/models/inventory/countings_inventory_model.dart';
import 'package:celta_inventario/pages/product_inventory_page/controller/consult_product_controller.dart';
import 'package:celta_inventario/pages/product_inventory_page/product_inventory_provider.dart';
import 'package:celta_inventario/pages/product_inventory_page/quantity_inventory_provider.dart';
import 'package:celta_inventario/pages/product_inventory_page/widgets/consult_product_widget.dart';
import 'package:celta_inventario/pages/product_inventory_page/widgets/consulted_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductInventoryPage extends StatefulWidget {
  const ProductInventoryPage({Key? key}) : super(key: key);

  @override
  _ProductInventoryPageState createState() => _ProductInventoryPageState();
}

class _ProductInventoryPageState extends State<ProductInventoryPage> {
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
    ProductInventoryProvider productProvider =
        Provider.of(context, listen: true);
    QuantityInventoryProvider quantityProvider =
        Provider.of(context, listen: true);
    final countings =
        ModalRoute.of(context)!.settings.arguments as CountingsInventoryModel;

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
