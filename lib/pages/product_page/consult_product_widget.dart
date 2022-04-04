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
  final bool isLoadingEanOrPlu;
  final Function() consultAndAddProduct;
  const ConsultProductWidget({
    Key? key,
    required this.formKey,
    required this.isIndividual,
    required this.consultProductFocusNode,
    required this.isLoadingEanOrPlu,
    required this.consultAndAddProduct,
  }) : super(key: key);

  @override
  State<ConsultProductWidget> createState() => _ConsultProductWidgetState();
}

class _ConsultProductWidgetState extends State<ConsultProductWidget> {
  String _scanBarcode = '';

  static final TextEditingController _consultProductController =
      TextEditingController();

  alterFocusToConsultProduct() {
    ConsultProductController.instance.alterFocusToConsultProduct(
      consultProductFocusNode: widget.consultProductFocusNode,
      context: context,
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
                      await widget.consultAndAddProduct();
                      _consultProductController.clear();
                    },
                    focusNode: widget.consultProductFocusNode,
                    enabled: widget.isLoadingEanOrPlu ||
                            quantityProvider.isLoadingQuantity
                        ? false
                        : true,
                    autofocus: true,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    inputFormatters: [LengthLimitingTextInputFormatter(14)],
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
                onPressed: widget.isLoadingEanOrPlu
                    ? null
                    : () {
                        _consultProductController.clear();
                        alterFocusToConsultProduct();
                      },
                icon: Icon(
                  Icons.delete,
                  color: widget.isLoadingEanOrPlu ? null : Colors.red,
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
                  child: widget.isLoadingEanOrPlu ||
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 70),
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
                                  widget.isIndividual
                                      ? 'CONSULTAR E INSERIR UNIDADE'
                                      : 'CONSULTAR OU ESCANEAR',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans',
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  !widget.isIndividual
                                      ? Icons.camera_alt_outlined
                                      : Icons.add,
                                  size: 40,
                                ),
                                if (widget.isIndividual)
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
                  onPressed: widget.isLoadingEanOrPlu ||
                          quantityProvider.isLoadingQuantity
                      ? null
                      : () async {
                          if (_consultProductController.text.isEmpty) {
                            await ConsultProductController.instance
                                .scanBarcodeNormal(
                              scanBarCode: _scanBarcode,
                              consultProductController:
                                  _consultProductController,
                            );

                            //se ler algum código, vai consultar o produto
                            if (_consultProductController.text.isNotEmpty) {
                              await widget.consultAndAddProduct();
                            }
                          } else {
                            await widget.consultAndAddProduct();
                          }

                          if (productProvider.products.isNotEmpty &&
                              widget.isIndividual) {
                            _consultProductController.clear();
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
