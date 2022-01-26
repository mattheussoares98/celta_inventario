import 'package:celta_inventario/provider/inventory_provider.dart';
import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryItems extends StatelessWidget {
  const InventoryItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InventoryProvider inventoryProvider = Provider.of(context);
    ProductProvider productProvider = Provider.of(context);

    double height =
        inventoryProvider.inventorys[0].obsInventario.length > 30 ? 300 : 200;

    TextStyle _fontSizeStyle = TextStyle(
      fontSize: 20,
      color: Colors.black,
      fontFamily: 'OpenSans',
    );
    TextStyle _fontSizeAndBoldStyle = TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    return SizedBox(
      height: height,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2,
            color: Colors.green,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        elevation: 15,
        // color: Theme.of(context).colorScheme.primary,
        child: ListView.builder(
          itemCount: inventoryProvider.inventoryCount,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                productProvider.codigoInternoInventario =
                    inventoryProvider.inventorys[index].codigoInternoInventario;

                Navigator.of(context).pushNamed(
                  APPROUTES.COUNTINGS,
                  arguments: inventoryProvider.inventorys[index],
                );
              },
              //sem esse container, não funciona o gesture detector no campo inteiro
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                      child: Row(
                        children: [
                          Text(
                            'Empresa: ',
                            style: _fontSizeStyle,
                          ),
                          const SizedBox(height: 25),
                          Text(
                            inventoryProvider.inventorys[index].nomeempresa,
                            style: _fontSizeAndBoldStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    FittedBox(
                      child: Row(
                        children: [
                          Text(
                            'Tipo de estoque: ',
                            style: _fontSizeStyle,
                          ),
                          Text(
                            inventoryProvider.inventorys[index].nomeTipoEstoque,
                            style: _fontSizeAndBoldStyle,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    FittedBox(
                      child: Row(
                        children: [
                          Text(
                            'Responsável: ',
                            style: _fontSizeStyle,
                          ),
                          const SizedBox(height: 25),
                          Text(
                            inventoryProvider.inventorys[index].nomefuncionario,
                            style: _fontSizeAndBoldStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    FittedBox(
                      child: Row(children: [
                        Text(
                          'Congelado em: ',
                          style: _fontSizeStyle,
                        ),
                        const SizedBox(height: 25),
                        Text(
                          formatDate(
                            inventoryProvider
                                .inventorys[index].dataCongelamentoInventario,
                            [dd, '-', mm, '-', yyyy, ' ', hh, ':', mm, ':', ss],
                          ),
                          style: _fontSizeAndBoldStyle,
                        ),
                      ]),
                    ),
                    // const SizedBox(height: 5),
                    // Row(children: [
                    //   Text(
                    //     'Criado em: ',
                    //     style: _fontSizeStyle,
                    //   ),
                    //   const SizedBox(height: 25),
                    //   Text(
                    //     formatDate(
                    //       inventoryProvider
                    //           .inventorys[index].dataCriacaoInventario,
                    //       [dd, '-', mm, '-', yyyy, ' ', hh, ':', mm, ':', ss],
                    //     ),
                    //     style: _fontSizeAndBoldStyle,
                    //   ),
                    // ]),
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Observações: ',
                          style: _fontSizeStyle,
                        ),
                        Expanded(
                          child: Text(
                            inventoryProvider
                                    .inventorys[index].obsInventario.isEmpty
                                ? 'Não há observações'
                                : inventoryProvider
                                    .inventorys[index].obsInventario,
                            style: _fontSizeAndBoldStyle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
