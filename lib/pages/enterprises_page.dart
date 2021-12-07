import 'package:celta_inventario/models/enterprise.dart';
import 'package:flutter/material.dart';

class EnterprisesPage extends StatelessWidget {
  const EnterprisesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Enterprise enterprise =
        ModalRoute.of(context)!.settings.arguments as Enterprise;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empresas'),
      ),
      body: Column(
        children: [
          Text(enterprise.nomeEmpresa),
        ],
      ),
    );
  }
}
