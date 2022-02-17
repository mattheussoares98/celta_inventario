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

      enterpriseProvider.getEnterprises(
        userIdentity: loginProvider.userIdentity!,
        baseUrl: loginProvider.userBaseUrl,
      );
    }

    enterpriseProvider.enterpriseErrorMessage != '' ? tryAgain() : null;

    isLoaded = true;
  }

  tryAgain() {
    LoginProvider loginProvider = Provider.of(
      context,
      listen: true,
    );
    EnterpriseProvider enterpriseProvider = Provider.of(
      context,
      listen: true,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ErrorMessage(text: enterpriseProvider.enterpriseErrorMessage),
        TextButton(
          onPressed: () {
            setState(() {
              enterpriseProvider.getEnterprises(
                userIdentity: loginProvider.userIdentity!,
                baseUrl: loginProvider.userBaseUrl,
              );
            });
          },
          child: const Text('Tentar novamente'),
        ),
      ],
    );
  }

  Padding consultingEnterprises() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Consultando empresas',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    EnterpriseProvider enterpriseProvider =
        Provider.of<EnterpriseProvider>(context, listen: true);

    print(enterpriseProvider.enterpriseErrorMessage);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EMPRESAS',
        ),
      ),
      body: enterpriseProvider.isChargingEnterprises
          ? consultingEnterprises()
          : enterpriseProvider.enterpriseErrorMessage != ''
              ? tryAgain()
              : EnterpriseWidget(),
    );
  }
}
