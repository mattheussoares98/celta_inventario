import 'package:celta_inventario/provider/login_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
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
    GestureDetector imagem(
        {String? imagePath, String? routine, String? route}) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(route!);
        },
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
                      // fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await loginProvider.logout();
              } catch (e) {
                print(e);
                e;
              } finally {
                print('authOrHome');
                Navigator.of(context).pushReplacementNamed(APPROUTES.HOME);
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        title: const Center(
          child: Text(
            'Selecione a rotina desejada',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            imagem(
              imagePath: 'lib/assets/inventory.jpg',
              routine: 'Inventário',
              route: APPROUTES.INVENTORY,
            ),
            const Divider(color: Colors.black),
            imagem(
              imagePath: 'lib/assets/pedidoDeVendas.jpg',
              routine: 'Pedido de vendas',
              route: APPROUTES.SALES,
            ),
            const Divider(color: Colors.black),
            imagem(
              imagePath: 'lib/assets/stock.jpg',
              routine: 'Estoque',
              route: APPROUTES.STOCK,
            ),
            const Divider(color: Colors.black),
          ],
        ),
      ),
    );
  }
}
