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

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[350],
        border: Border.all(
          color: Colors.black,
        ),
      ),
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
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('Empresa: '),
                        const SizedBox(height: 25),
                        Text(
                          inventoryProvider.inventorys[index].codigoEmpresa,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Tipo de estoque: '),
                        const SizedBox(height: 25),
                        Text(inventoryProvider
                            .inventorys[index].nomeTipoEstoque),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Responsável: '),
                        const SizedBox(height: 25),
                        Text(inventoryProvider
                            .inventorys[index].nomefuncionario),
                      ],
                    ),
                    Row(children: [
                      const Text('Data de congelamento: '),
                      const SizedBox(height: 25),
                      Text(
                        formatDate(
                          inventoryProvider
                              .inventorys[index].dataCongelamentoInventario,
                          [dd, '-', mm, '-', yyyy, ' ', hh, ':', mm, ':', ss],
                        ),
                      ),
                    ]),
                    Row(children: [
                      const Text('Data de criação: '),
                      const SizedBox(height: 25),
                      Text(
                        formatDate(
                          inventoryProvider
                              .inventorys[index].dataCriacaoInventario,
                          [dd, '-', mm, '-', yyyy, ' ', hh, ':', mm, ':', ss],
                        ),
                      ),
                    ]),
                    Row(
                      children: [
                        const Text('Observações: '),
                        Text(
                          inventoryProvider
                                  .inventorys[index].obsInventario.isEmpty
                              ? 'Não há observações'
                              : inventoryProvider
                                  .inventorys[index].obsInventario,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
