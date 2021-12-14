import 'package:celta_inventario/components/enterprise_widget.dart';
import 'package:celta_inventario/provider/enterprise_provider.dart';
import 'package:celta_inventario/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterprisePage extends StatefulWidget {
  const EnterprisePage({Key? key}) : super(key: key);

  @override
  State<EnterprisePage> createState() => EnterprisePageState();
}

class EnterprisePageState extends State<EnterprisePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<EnterpriseProvider>(context, listen: false).getEnterprises();
  }

  @override
  Widget build(BuildContext context) {
    EnterpriseProvider enterpriseProvider =
        Provider.of<EnterpriseProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('EMPRESAS'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (enterpriseProvider.isChargingEnterprises)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: const [
                      Text(
                        'Carregando empresas',
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
            if (enterpriseProvider.enterpriseMessage != '')
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        enterpriseProvider.enterpriseMessage,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        enterpriseProvider.getEnterprises();
                      });
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            if (!enterpriseProvider.isChargingEnterprises &&
                enterpriseProvider.enterpriseCount > 0)
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Selecione a empresa',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const Divider(color: Colors.black),
            const EnterpriseWidget(),
          ],
        ),
      ),
    );
  }
}
