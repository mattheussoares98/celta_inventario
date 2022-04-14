import 'package:celta_inventario/components/personalized_card.dart';
import 'package:celta_inventario/pages/enterprise_inventory_page/enterprise_inventory_provider.dart';
import 'package:celta_inventario/pages/product_inventory_page/product_inventory_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterpriseInventoryItems extends StatefulWidget {
  const EnterpriseInventoryItems({Key? key}) : super(key: key);

  @override
  State<EnterpriseInventoryItems> createState() =>
      _EnterpriseInventoryItemsState();
}

class _EnterpriseInventoryItemsState extends State<EnterpriseInventoryItems> {
  @override
  Widget build(BuildContext context) {
    EnterpriseInventoryProvider enterpriseProvider =
        Provider.of(context, listen: true);
    ProductInventoryProvider productProvider = Provider.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Selecione a empresa',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: enterpriseProvider.enterpriseCount,
            itemBuilder: (ctx, index) {
              return PersonalizedCard().personalizedCard(
                context: context,
                child: ListTile(
                  title: Text(
                    enterpriseProvider.enterprises[index].nomeEmpresa,
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  leading: Text(
                    enterpriseProvider.enterprises[index].codigoEmpresa
                        .toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  onTap: () {
                    productProvider.codigoInternoEmpresa = enterpriseProvider
                        .enterprises[index].codigoInternoEmpresa;

                    Navigator.of(context).pushNamed(
                      APPROUTES.INVENTORY,
                      arguments: enterpriseProvider.enterprises[index],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
