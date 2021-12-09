import 'package:celta_inventario/provider/login_provider.dart';
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
    LoginProvider loginProvider = Provider.of(context, listen: true);

    return SizedBox(
      height: loginProvider.enterprises.length * 71,
      width: 400,
      child: ListView.builder(
        itemCount: loginProvider.itemCount,
        itemBuilder: (ctx, index) {
          return Column(
            children: [
              ListTile(
                title: Text(loginProvider.enterprises[index].nomeEmpresa),
                trailing: Text(loginProvider
                    .enterprises[index].codigoInternoEmpresa
                    .toString()),
                onTap: () {
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
