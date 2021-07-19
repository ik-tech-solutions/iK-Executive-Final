import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constance/constance.dart' as constance;

class AppTheme {
  static bool isLightTheme = true;

  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline6: GoogleFonts.openSans(
        textStyle: TextStyle(
          color: base.headline6.color,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle1: GoogleFonts.openSans(
        textStyle: TextStyle(
          color: base.subtitle1.color,
          fontSize: 16,
        ),
      ),
      subtitle2: GoogleFonts.openSans(
        textStyle: TextStyle(
          color: base.subtitle2.color,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      bodyText2: GoogleFonts.openSans(
        textStyle: TextStyle(
          color: base.bodyText2.color,
          fontSize: 16,
        ),
      ),
      bodyText1: GoogleFonts.openSans(
        textStyle: TextStyle(
          color: base.bodyText1.color,
          fontSize: 14,
        ),
      ),
      button: GoogleFonts.openSans(
        textStyle: TextStyle(color: base.button.color, fontSize: 14, fontWeight: FontWeight.w600),
      ),
      caption: GoogleFonts.openSans(
        textStyle: TextStyle(color: base.caption.color, fontSize: 12),
      ),
      headline4: GoogleFonts.openSans(
        textStyle: TextStyle(color: base.headline4.color, fontSize: 34),
      ),
      headline3: GoogleFonts.openSans(
        textStyle: TextStyle(
          color: base.headline3.color,
          fontSize: 48,
        ),
      ),
      headline2: GoogleFonts.openSans(
        textStyle: TextStyle(
          color: base.headline2.color,
          fontSize: 60,
        ),
      ),
      headline1: GoogleFonts.openSans(
        textStyle: TextStyle(
          color: base.headline1.color,
          fontSize: 96,
        ),
      ),
      headline5: GoogleFonts.openSans(
        textStyle: TextStyle(
          color: base.headline5.color,
          fontSize: 24,
        ),
      ),
      overline: GoogleFonts.openSans(
        textStyle: TextStyle(
          color: base.overline.color,
          fontSize: 10,
        ),
      ),
    );
  }

  static ThemeData getTheme() {
    if (isLightTheme) {
      return lightTheme();
    } else {
      return darkTheme();
    }
  }

  static ThemeData lightTheme() {
    Color primaryColor = HexColor(constance.primaryColorString);
    Color secondaryColor = HexColor(constance.secondaryColorString);
    final ColorScheme colorScheme = const ColorScheme.light().copyWith(
      primary: Colors.black,
      secondary: Colors.black,
    );
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      colorScheme: colorScheme,
      primaryColor: primaryColor,
      buttonColor: primaryColor,
      indicatorColor: Colors.white,
      splashColor: Colors.white24,
      splashFactory: InkRipple.splashFactory,
      accentColor: secondaryColor,
      canvasColor: Colors.white,
      backgroundColor: const Color(0xFFEEECEB),
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      errorColor: const Color(0xFFB00020),
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildTextTheme(base.accentTextTheme),
      platform: TargetPlatform.iOS,
      cursorColor: primaryColor,
    );
  }

  static ThemeData darkTheme() {
    Color primaryColor = HexColor(constance.primaryColorString);
    Color secondaryColor = HexColor(constance.secondaryColorString);
    final ColorScheme colorScheme = const ColorScheme.light().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
    );
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      colorScheme: colorScheme,
      primaryColor: primaryColor,
      buttonColor: primaryColor,
      indicatorColor: Colors.white,
      splashColor: Colors.white24,
      splashFactory: InkRipple.splashFactory,
      accentColor: secondaryColor,
      canvasColor: Colors.white,
      backgroundColor: Colors.grey[850],
      scaffoldBackgroundColor: Colors.black,
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      cursorColor: primaryColor,
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildTextTheme(base.accentTextTheme),
      platform: TargetPlatform.iOS,
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
