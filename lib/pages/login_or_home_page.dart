import 'package:celta_inventario/pages/login_page.dart';
import 'package:celta_inventario/pages/home_page.dart';
import 'package:celta_inventario/provider/login_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthOrHoMePage extends StatefulWidget {
  const AuthOrHoMePage({Key? key}) : super(key: key);

  @override
  State<AuthOrHoMePage> createState() => _AuthOrHoMePageState();
}

class _AuthOrHoMePageState extends State<AuthOrHoMePage> {
  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: true);

    return Scaffold(
      body: StreamBuilder(
        stream: loginProvider.authStream,
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.data == false || snapshot.data == null) {
            return LoginPage();
          } else {
            return HomePage();
          }
        },
      ),
    );
  }
}
