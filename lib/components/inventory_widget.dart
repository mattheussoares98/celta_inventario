import 'package:celta_inventario/provider/inventory_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryWidget extends StatefulWidget {
  final String? enterpriseCode;
  const InventoryWidget({
    Key? key,
    this.enterpriseCode,
  }) : super(key: key);

  @override
  _InventoryWidgetState createState() => _InventoryWidgetState();
}

class _InventoryWidgetState extends State<InventoryWidget> {
  @override
  void initState() {
    super.initState();
    Provider.of<InventoryProvider>(context, listen: false).getInventory(
      widget.enterpriseCode!,
    );
  }

  @override
  Widget build(BuildContext context) {
    InventoryProvider inventoryProvider = Provider.of(context, listen: true);
    return Column(
      children: [
        if (!inventoryProvider.isChargingInventorys &&
            inventoryProvider.inventoryCount > 0)
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Selecione o inventário',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        const Divider(color: Colors.black),
        if (inventoryProvider.isChargingInventorys)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: const [
                  Text(
                    'Carregando inventários',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        if (!inventoryProvider.isChargingInventorys &&
            inventoryProvider.inventoryCount > 0)
          Container(
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
                                inventoryProvider
                                    .inventorys[index].codigoEmpresa,
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
                                inventoryProvider.inventorys[index]
                                    .dataCongelamentoInventario,
                                [
                                  dd,
                                  '-',
                                  mm,
                                  '-',
                                  yyyy,
                                  ' ',
                                  hh,
                                  ':',
                                  mm,
                                  ':',
                                  ss
                                ],
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
                                [
                                  dd,
                                  '-',
                                  mm,
                                  '-',
                                  yyyy,
                                  ' ',
                                  hh,
                                  ':',
                                  mm,
                                  ':',
                                  ss
                                ],
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
          ),
        if (inventoryProvider.inventoryErrorMessage != '' &&
            !inventoryProvider.isChargingInventorys)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    inventoryProvider.inventoryErrorMessage,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    inventoryProvider.getInventory(widget.enterpriseCode!);
                  });
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          )
      ],
    );
  }
}
