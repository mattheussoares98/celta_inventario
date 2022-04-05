import 'package:celta_inventario/provider/login_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';

class ConfirmLogoutComponent {
  static final ConfirmLogoutComponent instance = ConfirmLogoutComponent._();

  ConfirmLogoutComponent._();

  confirmLogout({
    required LoginProvider loginProvider,
    required BuildContext context,
  }) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            actionsPadding: EdgeInsets.only(bottom: 10),
            actionsAlignment: MainAxisAlignment.center,
            title: const FittedBox(
              child: Text(
                'Deseja realmente\nfazer o logout?',
                style: TextStyle(
                  letterSpacing: 2,
                  fontSize: 50,
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await loginProvider.logout();
                  Navigator.of(context)
                      .pushReplacementNamed(APPROUTES.LOGIN_PAGE);
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Sim',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Não',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
