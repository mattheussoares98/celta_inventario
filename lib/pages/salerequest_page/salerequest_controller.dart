import 'package:celta_inventario/pages/salerequest_page/enterprise_salerequest_provider.dart';
import 'package:celta_inventario/utils/error_message.dart';
import 'package:flutter/material.dart';

class SalesController {
  tryAgain(
    EnterpriseSaleRequestProvider enterpriseSaleRequestProvider,
  ) {
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
}
