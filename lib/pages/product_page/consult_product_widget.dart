import 'package:celta_inventario/models/countings.dart';
import 'package:celta_inventario/pages/product_page/consult_product_controller.dart';
import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ConsultProductWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool isIndividual;
  final FocusNode consultProductFocusNode;
  // final Function() consultAndAddProduct;
  final TextEditingController consultProductController;
  const ConsultProductWidget({
    Key? key,
    required this.formKey,
    required this.isIndividual,
    required this.consultProductFocusNode,
    // required this.consultAndAddProduct,
    required this.consultProductController,
  }) : super(key: key);

  @override
  State<ConsultProductWidget> createState() => _ConsultProductWidgetState();
}

class _ConsultProductWidgetState extends State<ConsultProductWidget> {
  alterFocusToConsultProduct() {
    ConsultProductController.instance.alterFocusToConsultProduct(
      consultProductFocusNode: widget.consultProductFocusNode,
      context: context,
    );
  }

  Future<void> consultAndAddProduct() async {
    final countings = ModalRoute.of(context)!.settings.arguments as Countings;

    await ConsultProductController.instance.consultAndAddProduct(
      context: context,
      scanBarCode: widget.consultProductController.text,
      codigoInternoInvCont: countings.codigoInternoInvCont,
      consultProductFocusNode: widget.consultProductFocusNode,
      isIndividual: widget.isIndividual,
    );
  }

  @override
  Widget build(BuildContext context) {
    QuantityProvider quantityProvider = Provider.of(context, listen: true);
    ProductProvider productProvider = Provider.of(context, listen: true);

    return Column(
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
                  key: widget.formKey,
                  child: TextFormField(
                    onFieldSubmitted: (value) async {
                      await consultAndAddProduct();
                      widget.consultProductController.clear();
                    },
                    focusNode: widget.consultProductFocusNode,
                    enabled: productProvider.isLodingEanOrPlu ||
                            quantityProvider.isLoadingQuantity
                        ? false
                        : true,
                    autofocus: true,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    inputFormatters: [LengthLimitingTextInputFormatter(14)],
                    controller: widget.consultProductController,
                    onChanged: (value) => setState(() {
                      // print(widget.consultProductController.text);
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
                onPressed: productProvider.isLodingEanOrPlu ||
                        quantityProvider.isLoadingQuantity
                    ? null
                    : () {
                        widget.consultProductController.clear();
                        alterFocusToConsultProduct();
                      },
                icon: Icon(
                  Icons.delete,
                  color: productProvider.isLodingEanOrPlu ||
                          quantityProvider.isLoadingQuantity
                      ? null
                      : Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 70),
                    maximumSize: Size(double.infinity, 70),
                  ),
                  child: productProvider.isLodingEanOrPlu ||
                          quantityProvider.isLoadingQuantity
                      ? FittedBox(
                          child: Row(
                            children: [
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
                              Container(
                                height: 100,
                                width: 100,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        )
                      : FittedBox(
                          child: Row(
                            children: [
                              Text(
                                widget.isIndividual
                                    ? 'CONSULTAR E INSERIR UNIDADE'
                                    : 'CONSULTAR OU ESCANEAR',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 50,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                widget.isIndividual
                                    ? Icons.add
                                    : Icons.camera_alt_outlined,
                                size: 70,
                              ),
                              if (widget.isIndividual)
                                Text(
                                  '1',
                                  style: TextStyle(
                                    fontSize: 70,
                                  ),
                                ),
                            ],
                          ),
                        ),
                  onPressed: productProvider.isLodingEanOrPlu ||
                          quantityProvider.isLoadingQuantity
                      ? null
                      : () async {
                          if (widget.consultProductController.text.isEmpty) {
                            //se não digitar o ean ou plu, vai abrir a câmera
                            await ConsultProductController.instance
                                .scanBarcodeNormal(
                              scanBarCode: widget.consultProductController.text,
                              consultProductController:
                                  widget.consultProductController,
                            );
                          }

                          //se ler algum código, vai consultar o produto
                          if (widget.consultProductController.text.isNotEmpty) {
                            await consultAndAddProduct();
                          }

                          if (productProvider.products.isNotEmpty &&
                              widget.isIndividual) {
                            widget.consultProductController.clear();
                            alterFocusToConsultProduct();
                          }
                        },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
