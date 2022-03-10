import 'package:celta_inventario/pages/auth_or_home_page.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    Widget example1 = SplashScreenView(
      navigateRoute: AuthOrHoMePage(),
      duration: 5000,
      imageSize: width.toInt(),
      imageSrc: "lib/assets/Images/LogoCeltaTransparente.png",
      text: "CELTAWARE",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 40.0,
      ),
      colors: [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );

    Widget example2 = SplashScreenView(
      navigateRoute: AuthOrHoMePage(),
      duration: 3000,
      imageSize: width.toInt(),
      imageSrc: "lib/assets/Images/LogoCeltaTransparente.png",
      text: "CELTAWARE",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 30.0,
      ),
      colors: [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );

    return Container(
      child: example1,
    );
  }
}
