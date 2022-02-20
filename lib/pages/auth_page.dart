import 'dart:math';
import 'package:celta_inventario/components/login/auth_form.dart';
import 'package:celta_inventario/utils/colors_theme.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // Colors.lightGreen,
                  Colors.white,
                  Theme.of(context).colorScheme.primary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 30,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: const FittedBox(
                    child: Text(
                      'Celta mobile',
                      style: TextStyle(
                        fontSize: 100,
                        color: ColorsTheme.text,
                        fontFamily: 'BebasNeue',
                      ),
                    ),
                  ),
                ),
              ),
              AuthForm(
                formKey: _key,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
