import 'package:celta_inventario/pages/auth_or_home_page.dart';
import 'package:celta_inventario/pages/auth_page.dart';
import 'package:celta_inventario/pages/enterprise_page.dart';
import 'package:celta_inventario/pages/inventory_page.dart';
import 'package:celta_inventario/pages/sales_page.dart';
import 'package:celta_inventario/pages/stock_page.dart';
import 'package:celta_inventario/provider/inventory_provider.dart';
import 'package:celta_inventario/provider/login_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: const AuthOrHoMePage(),
        routes: {
          APPROUTES.HOME: (ctx) => const AuthOrHoMePage(),
          APPROUTES.AUTH: (ctx) => const AuthPage(),
          APPROUTES.ENTERPRISES: (ctx) => const EnterprisePage(),
          APPROUTES.INVENTORY: (ctx) => const InventoryPage(),
          APPROUTES.STOCK: (ctx) => const StockPage(),
          APPROUTES.SALES: (ctx) => const SalesPage(),
        },
      ),
    ),
  );
}
