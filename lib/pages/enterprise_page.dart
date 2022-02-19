import 'package:celta_inventario/components/enterprise/enterprise_widget.dart';
import 'package:celta_inventario/components/error_message.dart';
import 'package:celta_inventario/provider/enterprise_provider.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/user_identity.dart';
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
    super.didChangeDependencies();
    EnterpriseProvider enterpriseProvider = Provider.of(
      context,
      listen: true,
    );

    if (!isLoaded) {
      enterpriseProvider.getEnterprises(
        userIdentity: UserIdentity.identity,
        baseUrl: BaseUrl.url,
      );
    }

    enterpriseProvider.enterpriseErrorMessage != '' ? tryAgain() : null;

    isLoaded = true;
  }

  tryAgain() {
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
                userIdentity: UserIdentity.identity,
                baseUrl: BaseUrl.url,
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
