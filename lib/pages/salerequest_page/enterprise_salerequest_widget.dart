import 'package:celta_inventario/components/personalized_card.dart';
import 'package:celta_inventario/pages/salerequest_page/enterprise_salerequest_provider.dart';
import 'package:flutter/material.dart';

class EnterpriseWidget {
  EnterpriseWidget();

  enterpriseWidget({
    required EnterpriseSaleRequestProvider enterpriseSaleRequestProvider,
    // required int index,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: enterpriseSaleRequestProvider.enterprises.length,
          itemBuilder: (context, index) {
            return PersonalizedCard().personalizedCard(
              context: context,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                        enterpriseSaleRequestProvider.enterprises[index].name),
                    subtitle: Text(
                      'CNPJ: ' +
                          enterpriseSaleRequestProvider.enterprises[index].cnpj,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
