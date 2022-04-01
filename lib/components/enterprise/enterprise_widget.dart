import 'package:celta_inventario/provider/enterprise_provider.dart';
import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterpriseWidget extends StatefulWidget {
  const EnterpriseWidget({Key? key}) : super(key: key);

  @override
  State<EnterpriseWidget> createState() => _EnterpriseWidgetState();
}

class _EnterpriseWidgetState extends State<EnterpriseWidget> {
  @override
  Widget build(BuildContext context) {
    EnterpriseProvider loginProvider = Provider.of(context, listen: true);
    ProductProvider productProvider = Provider.of(context);

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
            itemCount: loginProvider.enterpriseCount,
            itemBuilder: (ctx, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                elevation: 6,
                // color: Theme.of(context).colorScheme.primary,
                child: ListTile(
                  title: Text(
                    loginProvider.enterprises[index].nomeEmpresa,
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  leading: Text(
                    loginProvider.enterprises[index].codigoEmpresa.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  onTap: () {
                    productProvider.codigoInternoEmpresa =
                        loginProvider.enterprises[index].codigoInternoEmpresa;

                    Navigator.of(context).pushNamed(
                      APPROUTES.INVENTORY,
                      arguments: loginProvider.enterprises[index],
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
