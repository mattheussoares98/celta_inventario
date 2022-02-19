import 'package:celta_inventario/provider/login_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

bool carregando = false;

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    InkWell imagem({
      String? imagePath,
      String? routine,
      String? route,
    }) {
      return InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            route!,
            arguments: UserIdentity.identity,
          );
        },
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            side: BorderSide(
              width: 3,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  imagePath!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  // height: 30,
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    border: Border.all(
                      style: BorderStyle.none,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      routine!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              LoginProvider loginProvider =
                  Provider.of<LoginProvider>(context, listen: false);
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      actionsAlignment: MainAxisAlignment.center,
                      title: const FittedBox(
                        child: Text(
                          'Deseja realmente fazer o logout?',
                          style: TextStyle(
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () async {
                            await loginProvider.logout();
                            Navigator.of(context)
                                .pushReplacementNamed(APPROUTES.HOME);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Sim',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Não',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            },
          ),
        ],
        title: Center(
          child: FittedBox(
            child: Text(
              'Selecione a rotina desejada',
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 5),
            imagem(
              imagePath: 'lib/assets/Images/inventory.jpg',
              routine: 'Inventário',
              route: APPROUTES.ENTERPRISES,
            ),
            imagem(
              imagePath: 'lib/assets/Images/pedidoDeVendas.jpg',
              routine: 'Pedido de compras',
              route: APPROUTES.SALES,
            ),
            imagem(
              imagePath: 'lib/assets/Images/stock.jpg',
              routine: 'Estoque',
              route: APPROUTES.STOCK,
            ),
          ],
        ),
      ),
    );
  }
}
