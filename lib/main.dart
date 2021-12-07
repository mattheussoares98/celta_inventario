import 'package:celta_inventario/pages/auth_or_home_page.dart';
import 'package:celta_inventario/pages/enterprises_page.dart';
import 'package:celta_inventario/provider/login_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: const AuthOrHoMePage(),
        routes: {
          APPROUTES.HOME: (ctx) => const AuthOrHoMePage(),
          APPROUTES.ENTERPRISES: (ctx) => const EnterprisesPage(),
        },
      ),
    ),
  );
}
