import 'package:celta_inventario/provider/enterprise_salerequest_provider.dart';
import 'package:flutter/material.dart';

class EnterpriseWidget {
  EnterpriseWidget();

  checkBoxListTile({
    required EnterpriseSaleRequestProvider enterpriseSaleRequestProvider,
    // required int index,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: enterpriseSaleRequestProvider.enterprises.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                        title: Text(enterpriseSaleRequestProvider
                            .enterprises[index]['name']),
                        subtitle: Text(
                          'CNPJ: ' +
                              enterpriseSaleRequestProvider.enterprises[index]
                                  ['cnpj'],
                        )),
                  ),
                  const SizedBox(height: 5),
                ],
              );
            }),
      ),
    );
  }
}
