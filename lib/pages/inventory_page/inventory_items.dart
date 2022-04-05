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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Selecione o inventário',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: inventoryProvider.inventoryCount,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  productProvider.codigoInternoInventario = inventoryProvider
                      .inventorys[index].codigoInternoInventario;

                  Navigator.of(context).pushNamed(
                    APPROUTES.COUNTINGS,
                    arguments: inventoryProvider.inventorys[index],
                  );
                },
                //sem esse Card, não funciona o gesture detector no campo inteiro
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Empresa: ',
                              style: _fontSizeStyle,
                            ),
                            const SizedBox(height: 25),
                            Expanded(
                              child: Text(
                                inventoryProvider.inventorys[index].nomeempresa,
                                style: _fontSizeAndBoldStyle,
                                maxLines: 2,
                              ),
                            ),
                          ],
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
                                inventoryProvider
                                    .inventorys[index].nomeTipoEstoque,
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
                                inventoryProvider
                                    .inventorys[index].nomefuncionario,
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
                                inventoryProvider.inventorys[index]
                                    .dataCongelamentoInventario,
                                [
                                  dd,
                                  '/',
                                  mm,
                                  '/',
                                  yyyy,
                                  ' ',
                                  HH,
                                  ':',
                                  mm,
                                  ':',
                                  ss
                                ],
                              ),
                              style: _fontSizeAndBoldStyle,
                            ),
                          ]),
                        ),
                        //data de criação do inventário
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
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Observações: ',
                              style: _fontSizeStyle,
                            ),
                            if (inventoryProvider
                                    .inventorys[index].obsInventario.length <
                                19)
                              Expanded(
                                child: Text(
                                  inventoryProvider.inventorys[index]
                                          .obsInventario.isEmpty
                                      ? 'Não há observações'
                                      : inventoryProvider
                                          .inventorys[index].obsInventario,
                                  style: _fontSizeAndBoldStyle,
                                ),
                              ),
                          ],
                        ),
                        if (inventoryProvider
                                .inventorys[index].obsInventario.length >
                            19)
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  inventoryProvider
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
