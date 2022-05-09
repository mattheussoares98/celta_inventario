import 'package:celta_inventario/pages/login_page/login_page.dart';
import 'package:celta_inventario/pages/home_page/home_page.dart';
import 'package:celta_inventario/pages/login_page/login_provider.dart';
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
      body: StreamBuilder<bool>(
        stream: loginProvider.authStream,
        builder: (context, snapshot) {
          if (snapshot.data == false || snapshot.data == null) {
            return const LoginPage();
          } else {
            return const HomePage();
          }
        },
      ),
    );
  }
}
