import 'package:celta_inventario/pages/home_page/image_component.dart';
import 'package:celta_inventario/pages/login_page/login_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:celta_inventario/utils/colors_theme.dart';
import 'package:celta_inventario/utils/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: ColorsTheme.text,
            ),
            onPressed: () async {
              ShowAlertDialog().showAlertDialog(
                context: context,
                title: 'Deseja fazer o logout?',
                function: () async {
                  await loginProvider.logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      APPROUTES.LOGIN_OR_HOME_PAGE, (route) => false);
                },
              );
            },
          ),
        ],
        title: const Center(
          child: const FittedBox(
            child: Text(
              'Selecione a rotina desejada',
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 5),
            ImageComponent.instance.image(
              imagePath: 'lib/assets/Images/inventory.jpg',
              routine: 'Inventário',
              route: APPROUTES.ENTERPRISES,
              context: context,
            ),
            ImageComponent.instance.image(
              imagePath: 'lib/assets/Images/pedidoDeVendas.jpg',
              routine: 'Pedido de vendas',
              route: APPROUTES.SALES,
              context: context,
            ),
            ImageComponent.instance.image(
              imagePath: 'lib/assets/Images/stock.jpg',
              routine: 'Estoque',
              route: APPROUTES.STOCK,
              context: context,
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
