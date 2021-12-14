import 'package:celta_inventario/provider/inventory_provider.dart';
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
    return inventoryProvider.isChargingInventorys
        ? Center(
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
          )
        : SizedBox(
            height: 500,
            child: ListView.builder(
              itemCount: inventoryProvider.inventoryCount,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Text(inventoryProvider.inventorys[index].nomeTipoEstoque),
                    Text(inventoryProvider.inventorys[index].nomeempresa),
                    Text(inventoryProvider.inventorys[index].nomefuncionario),
                    Text(inventoryProvider.inventorys[index].obsInventario),
                    Text(inventoryProvider
                        .inventorys[index].codigoInternoEmpresa
                        .toString()),
                    Text(inventoryProvider
                        .inventorys[index].codigoInternoInventario
                        .toString()),
                    Text(inventoryProvider
                        .inventorys[index].dataCongelamentoInventario
                        .toString()),
                    Text(inventoryProvider
                        .inventorys[index].dataCriacaoInventario
                        .toString()),
                  ],
                );
              },
            ),
          );
  }
}
