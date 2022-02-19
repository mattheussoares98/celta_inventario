// @dart=2.9
import 'package:celta_inventario/pages/auth_or_home_page.dart';
import 'package:celta_inventario/pages/auth_page.dart';
import 'package:celta_inventario/pages/counting_page.dart';
import 'package:celta_inventario/pages/enterprise_page.dart';
import 'package:celta_inventario/pages/inventory_page.dart';
import 'package:celta_inventario/pages/product_page.dart';
import 'package:celta_inventario/pages/sales_page.dart';
import 'package:celta_inventario/pages/stock_page.dart';
import 'package:celta_inventario/provider/counting_provider.dart';
import 'package:celta_inventario/provider/enterprise_provider.dart';
import 'package:celta_inventario/provider/inventory_provider.dart';
import 'package:celta_inventario/provider/login_provider.dart';
import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:celta_inventario/utils/responsive_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => EnterpriseProvider()),
        ChangeNotifierProvider(create: (_) => CountingProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => QuantityProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.green,
          secondaryHeaderColor: Colors.black,
          backgroundColor: Colors.lightGreen[100],
          appBarTheme: ThemeData().appBarTheme.copyWith(
                toolbarHeight: ResponsiveItems.appBarToolbarHeight,
                backgroundColor: Colors.green,
                centerTitle: true,
                titleTextStyle: TextStyle(
                  letterSpacing: 0.7,
                  color: Colors.white,
                  fontFamily: 'BebasNeue',
                  fontSize: 30,
                ),
              ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(
                decorationColor: Colors.green,
                color: Colors.green,
              ),
            ),
          ),
        ).copyWith(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: ResponsiveItems.headline6,
                  fontFamily: 'BebasNeue',
                ),
                bodyText1: TextStyle(
                  fontFamily: 'OpenSans',
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: Colors.green,
                secondary: Colors.white,
              ),
        ),
        debugShowCheckedModeBanner: false,
        // home: const AuthOrHoMePage(),
        routes: {
          APPROUTES.HOME: (ctx) => const AuthOrHoMePage(),
          APPROUTES.AUTH: (ctx) => const AuthPage(),
          APPROUTES.ENTERPRISES: (ctx) => const EnterprisePage(),
          APPROUTES.INVENTORY: (ctx) => const InventoryPage(),
          APPROUTES.STOCK: (ctx) => const StockPage(),
          APPROUTES.SALES: (ctx) => const SalesPage(),
          APPROUTES.COUNTINGS: (ctx) => const CountingPage(),
          APPROUTES.PRODUCTS: (ctx) => const ProductPage(),
        },
      ),
    ),
  );
}
