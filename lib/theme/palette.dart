import 'package:flutter/material.dart';


class Palette {
  static MaterialColor kToDark = const MaterialColor(
    0XFF4A154B, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff431344), //10%
      100: Color(0xff3b113c), //20%
      200: Color(0xff340f35), //30%
      300: Color(0xff2c0d2d), //40%
      400: Color(0xff250b26), //50%
      500: Color(0xff1e081e), //60%
      600: Color(0xff160616), //70%
      700: Color(0xff0f040f), //80%
      800: Color(0xff070207), //90%
      900: Color(0xff000000), //100%
    },
  );
}
