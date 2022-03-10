import 'package:celta_inventario/pages/auth_page.dart';
import 'package:celta_inventario/pages/home_page.dart';
import 'package:celta_inventario/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthOrHoMePage extends StatefulWidget {
  const AuthOrHoMePage({Key? key}) : super(key: key);

  @override
  State<AuthOrHoMePage> createState() => _AuthOrHoMePageState();
}

class _AuthOrHoMePageState extends State<AuthOrHoMePage> {
  //se não armazenar o future do FutureBuilder, colocar a função no initState
  //e chamar a função no FutureBuilder, o FutureBuilder fica em loop aí acaba
  //causando problema pra fazer o logou
  var _future;
  @override
  void initState() {
    super.initState();
    _future = LoginProvider().doAuth();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: true);

    return FutureBuilder(
      future: _future,
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
