import 'package:celta_inventario/pages/auth_page.dart';
import 'package:celta_inventario/pages/home_page.dart';
import 'package:celta_inventario/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthOrHoMePage extends StatelessWidget {
  const AuthOrHoMePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: true);

    return FutureBuilder(
      future: loginProvider.doAuth(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.error != null) {
          return const Center(
            child: Text('Erro para efetuar o login'),
          );
        } else {
          return loginProvider.isAuth ? const HomePage() : const AuthPage();
        }
      },
    );
  }
}
