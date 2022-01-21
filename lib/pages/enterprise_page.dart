import 'package:celta_inventario/components/enterprise_widget.dart';
import 'package:celta_inventario/components/error_message.dart';
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
  bool isLoaded = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    EnterpriseProvider enterpriseProvider = Provider.of(
      context,
      listen: true,
    );

    if (!isLoaded) {
      LoginProvider loginProvider = Provider.of(context, listen: false);

      enterpriseProvider.getEnterprises(loginProvider.userIdentity!);
    }

    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: false);
    EnterpriseProvider enterpriseProvider =
        Provider.of<EnterpriseProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'EMPRESAS',
          style: TextStyle(
            color: Colors.black,
            // fontFamily: 'BebasNeue',
            fontSize: 30,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: (!enterpriseProvider.isChargingEnterprises &&
                enterpriseProvider.enterpriseCount > 0)
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
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
          if (enterpriseProvider.enterpriseErrorMessage != '')
            Column(
              children: [
                ErrorMessage(text: enterpriseProvider.enterpriseErrorMessage),
                TextButton(
                  onPressed: () {
                    setState(() {
                      enterpriseProvider
                          .getEnterprises(loginProvider.userIdentity!);
                    });
                  },
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          if (!enterpriseProvider.isChargingEnterprises &&
              enterpriseProvider.enterpriseCount > 0)
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Selecione a empresa',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          // const Divider(color: Colors.black),
          const EnterpriseWidget(),
        ],
      ),
    );
  }
}
