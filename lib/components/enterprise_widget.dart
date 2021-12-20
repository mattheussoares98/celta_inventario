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

    return SizedBox(
      height: loginProvider.enterprises.length * 71,
      width: 400,
      child: ListView.builder(
        itemCount: loginProvider.enterpriseCount,
        itemBuilder: (ctx, index) {
          return Column(
            children: [
              ListTile(
                title: Text(loginProvider.enterprises[index].nomeEmpresa),
                trailing: Text(
                    loginProvider.enterprises[index].codigoEmpresa.toString()),
                onTap: () {
                  productProvider.codigoInternoEmpresa =
                      loginProvider.enterprises[index].codigoInternoEmpresa;

                  Navigator.of(context).pushNamed(
                    APPROUTES.INVENTORY,
                    arguments: loginProvider.enterprises[index],
                  );
                },
              ),
              const Divider(
                color: Colors.black,
              ),
            ],
          );
        },
      ),
    );
  }
}
