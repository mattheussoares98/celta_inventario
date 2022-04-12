import 'package:celta_inventario/pages/enterprise_page/enterprise_items.dart';
import 'package:celta_inventario/utils/error_message.dart';
import 'package:celta_inventario/pages/enterprise_page/enterprise_inventory_provider.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/consulting_widget.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterprisePage extends StatefulWidget {
  const EnterprisePage({Key? key}) : super(key: key);

  @override
  State<EnterprisePage> createState() => EnterprisePageState();
}

class EnterprisePageState extends State<EnterprisePage> {
  tryAgain(EnterpriseInventoryProvider enterpriseProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ErrorMessage(text: enterpriseProvider.errorMessage),
        TextButton(
          onPressed: () {
            enterpriseProvider.getEnterprises(
              userIdentity: UserIdentity.identity,
              baseUrl: BaseUrl.url,
            );
          },
          child: const Text('Tentar novamente'),
        ),
      ],
    );
  }

  getEnterprises(EnterpriseInventoryProvider enterpriseProvider) async {
    await enterpriseProvider.getEnterprises(
      userIdentity: UserIdentity.identity,
      baseUrl: BaseUrl.url,
    );
  }

  @override
  void initState() {
    super.initState();
    EnterpriseInventoryProvider enterpriseProvider =
        Provider.of(context, listen: false);
    getEnterprises(enterpriseProvider);
  }

  @override
  Widget build(BuildContext context) {
    EnterpriseInventoryProvider enterpriseProvider =
        Provider.of<EnterpriseInventoryProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EMPRESAS',
        ),
      ),
      body: enterpriseProvider.isLoadingEnterprises
          ? ConsultingWidget().consultingWidget(title: 'Consultando empresas')
          : enterpriseProvider.errorMessage != ''
              ? tryAgain(enterpriseProvider)
              : EnterpriseItems(),
    );
  }
}
