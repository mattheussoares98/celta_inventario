import 'package:celta_inventario/pages/sales_page/enterprise_widget.dart';
import 'package:celta_inventario/provider/enterprise_salerequest_provider.dart';
import 'package:celta_inventario/utils/error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  tryAgain(EnterpriseSaleRequestProvider enterpriseSaleRequestProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ErrorMessage(
          text: 'error', //tratar erro no provider
        ),
        TextButton(
          onPressed: () {
            enterpriseSaleRequestProvider.getEnterprises();
          },
          child: const Text('Tentar novamente'),
        ),
      ],
    );
  }

  getEnterprises(
    EnterpriseSaleRequestProvider enterpriseSaleRequestProvider,
  ) async {
    await enterpriseSaleRequestProvider.getEnterprises();
  }

  @override
  void initState() {
    super.initState();
    EnterpriseSaleRequestProvider enterpriseSaleRequestProvider =
        Provider.of(context, listen: false);
    getEnterprises(enterpriseSaleRequestProvider);
  }

  @override
  Widget build(BuildContext context) {
    EnterpriseSaleRequestProvider enterpriseSaleRequestProvider =
        Provider.of(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Pedido de vendas',
        ),
      ),
      body: Column(
        children: [
          EnterpriseWidget().checkBoxListTile(
            enterpriseSaleRequestProvider: enterpriseSaleRequestProvider,
          ),
        ],
      ),
    );
  }
}
