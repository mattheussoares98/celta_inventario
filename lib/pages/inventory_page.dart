import 'package:celta_inventario/components/enterprise_widget.dart';
import 'package:flutter/material.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventário'),
      ),
      body: Column(
        children: [
          const EnterpriseWidget(),
          Row(
            children: [],
          ),
        ],
      ),
    );
  }
}
