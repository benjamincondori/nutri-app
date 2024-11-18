import 'package:flutter/material.dart';

class MyColors {
  static Color primaryColor = const Color(0xFF15BE77);
  static Color secondaryColor = const Color(0xFF53E88B);
  static Color primaryColorDark = const Color(0xFF08935c);
  static Color textColorPrimary = const Color(0xFF7B6F72);

  static MaterialColor primarySwatch = const MaterialColor(
  0xFF15BE77,
  <int, Color>{
    10: Color(0xFFF5FFFA),  // Color más claro
    50: Color(0xFFE3F7ED),  
    100: Color(0xFFB3E9CF),
    200: Color(0xFF7FDCB2),
    250: Color(0xFF62D6A2),
    300: Color(0xFF4CCF94),
    400: Color(0xFF26C47E),
    500: Color(0xFF15BE77),  // Este es el color primario
    600: Color(0xFF12AB6B),
    700: Color(0xFF10975D),
    800: Color(0xFF0D844F),
    900: Color(0xFF096438),  // Color más oscuro
  },
);


  // static Color primaryOpacityColor = const Color.fromRGBO(6, 27, 80, 0.9);
}
