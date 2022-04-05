import 'package:celta_inventario/pages/home_page/home_page.dart';
import 'package:celta_inventario/pages/login_or_home_page.dart';
import 'package:celta_inventario/pages/login_page/login_page.dart';
import 'package:celta_inventario/pages/counting_page/counting_page.dart';
import 'package:celta_inventario/pages/enterprise_page/enterprise_page.dart';
import 'package:celta_inventario/pages/inventory_page/inventory_page.dart';
import 'package:celta_inventario/pages/product_page/product_page.dart';
import 'package:celta_inventario/pages/sales_page.dart';
import 'package:celta_inventario/pages/splash_screen.dart';
import 'package:celta_inventario/pages/stock_page.dart';
import 'package:celta_inventario/provider/counting_provider.dart';
import 'package:celta_inventario/provider/enterprise_provider.dart';
import 'package:celta_inventario/provider/inventory_provider.dart';
import 'package:celta_inventario/provider/login_provider.dart';
import 'package:celta_inventario/provider/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:celta_inventario/utils/colors_theme.dart';
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
          primaryColor: ColorsTheme.principalColor,
          secondaryHeaderColor: ColorsTheme.text,
          backgroundColor: Colors.lightGreen[100],
          appBarTheme: ThemeData().appBarTheme.copyWith(
                actionsIconTheme: IconThemeData(
                  color: Colors.black,
                ),
                toolbarHeight: ResponsiveItems.appBarToolbarHeight,
                backgroundColor: ColorsTheme.principalColor,
                centerTitle: true,
                titleTextStyle: TextStyle(
                  letterSpacing: 0.7,
                  color: ColorsTheme.appBarText,
                  fontFamily: 'BebasNeue',
                  fontSize: 30,
                ),
              ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
                color: ColorsTheme.elevatedButtonTextColor,
              ),
              primary: ColorsTheme.principalColor,
              onPrimary: ColorsTheme.text,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ).copyWith(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  color: ColorsTheme.headline6,
                  fontSize: ResponsiveItems.headline6,
                  fontFamily: 'BebasNeue',
                ),
                bodyText1: TextStyle(
                  fontFamily: 'OpenSans',
                  color: ColorsTheme.headline6,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: ColorsTheme.principalColor,
                secondary: ColorsTheme.text,
                onSecondary: ColorsTheme.principalColor,
              ),
        ),
        debugShowCheckedModeBanner: false,
        // home: const AuthOrHoMePage(),
        initialRoute: APPROUTES.AUTH_OR_HOME_PAGE,
        routes: {
          APPROUTES.AUTH_OR_HOME_PAGE: (ctx) => const AuthOrHoMePage(),
          APPROUTES.LOGIN_PAGE: (ctx) => const LoginPage(),
          APPROUTES.ENTERPRISES: (ctx) => const EnterprisePage(),
          APPROUTES.INVENTORY: (ctx) => const InventoryPage(),
          APPROUTES.STOCK: (ctx) => const StockPage(),
          APPROUTES.SALES: (ctx) => const SalesPage(),
          APPROUTES.COUNTINGS: (ctx) => const CountingPage(),
          APPROUTES.PRODUCTS: (ctx) => const ProductPage(),
          APPROUTES.SPLASHSCREEN: (ctx) => SplashScreen(),
          APPROUTES.HOME_PAGE: (ctx) => HomePage(),
        },
      ),
    ),
  );
}
