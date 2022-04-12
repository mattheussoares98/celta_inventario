import 'package:flutter/material.dart';

class PersonalizedCard {
  personalizedCard({
    required BuildContext context,
    required Widget child,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      elevation: 6,
      child: child,
    );
  }
}
