import 'package:celta_inventario/models/enterprise.dart';
import 'package:celta_inventario/provider/login_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterpriseWidget extends StatelessWidget {
  // final Enterprise enterprise;
  const EnterpriseWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: true);
    return SizedBox(
      height: 400,
      width: 400,
      child: ListView.builder(
        itemCount: loginProvider.itemCount,
        itemBuilder: (ctx, index) {
          return Column(
            children: [
              const Divider(
                color: Colors.black,
              ),
              ListTile(
                leading: Text(loginProvider.enterprises[index].codigoEmpresa),
                title: Text(loginProvider.enterprises[index].nomeEmpresa),
                trailing: Text(loginProvider
                    .enterprises[index].codigoInternoEmpresa
                    .toString()),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    APPROUTES.ENTERPRISES,
                    arguments: loginProvider.enterprises[index],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
