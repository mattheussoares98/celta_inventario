import 'package:celta_inventario/components/enterprise_widget.dart';
import 'package:celta_inventario/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  var _future;
  @override
  void initState() {
    super.initState();
    _future = LoginProvider().getEnterprises();
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider _loginProvider = Provider.of(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventário'),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: _future,
              builder: (ctx, snapshot) {
                print(_loginProvider.enterprises);
                return const EnterpriseWidget();
              }),
          // Row(
          //   children: [],
          // ),
        ],
      ),
    );
  }
}
