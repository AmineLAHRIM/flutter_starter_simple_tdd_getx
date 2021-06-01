import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultTheme {
  // Colors
  static const Color appBackgroundColor = Color(0xFFFFF7EC);
  static const Color topBarBackgroundColor = Color(0xFFFFD974);
  static const Color selectedTabBackgroundColor = Color(0xFFFFC442);
  static const Color primary = Color(0xFF4A62E2);

  /*static const Color secondaryLight = Color(0xFFF1F2FD);
  static const Color secondaryLight2 = Color(0xFFF7F8FE);*/
  static const Color secondaryLight = Color(0xFFE4E7FC);
  static Color colorLightLoading = secondaryLight.withOpacity(0.5);

  //static const Color secondaryLight2 = Color(0xFFF1F2FE);
  static const Color secondaryLight1 = Color(0xFFD3D9FC);
  static const Color secondaryLight2 = Color(0xFFF4F5FE);
  static const Color secondaryLight3 = Color(0xFFF7F8FE);
  static const Color BgLight = Color(0xFFF9FBFF);

  //static const Color bgLighter = Color(0xFFF7F8FE);
  static const Color primaryDark = Color(0xFF636978);
  static const Color secondary = Color(0xFF4B4C67);
  static const Color selectedFooter = Color(0xFFF82956);

  //static  Color selectedFooter = primary.withOpacity(0.9);
  static const Color footerShadow = Color(0xFFF5F5F5);
  static const Color hintColor = Color(0xFFBFC9FF);

  //static const Color textColor = Color(0xFF2E3034);

  static const Color danger = Color(0xFFF82956);
  static const Color success = Color(0xFF6DD400);
  static const Color warning = Color(0xFFF7B500);
  static const Color info = Color(0xFF636978);

  static const Color headlineTextColor = Color(0xFF192032);

  //static const Color subTitleTextColor = Color(0xFFADB3C1);
  static const Color subTitleTextColor = Color(0xFFB2B7C4);
  static const Color bg = Color(0xFF192032);
  static const Color bgDarker = Color(0xFF101521);
  static Color darkerItem = bg.withOpacity(0.2);

  //static const Color secondaryBg = Color(0xFFF5F5F5);
  static const Color secondaryBg = BgLight;
  static const Color inputBg = Colors.white;
  static const Color titleProfileColor = Color(0xFF231F53);
  static Color shadow = Color(0xFFDDDDDD);
  static Color borderCard = Color(0xFF707070).withOpacity(0.5);
  static const Color fb = Color(0xFF0041A8);
  static const Color twitter = Color(0xFF42AAFF);
  static const Color google = Color(0xFFF2F8FF);
  static const Color footertext = Color(0xFFC5CEE0);
  static const double radius = 10.0;

  // ThemeData
  static final ThemeData themeData = ThemeData(
      scaffoldBackgroundColor: bg,
      backgroundColor: bg,
      brightness: Brightness.light,
      primaryColor: headlineTextColor,
      textTheme: textTheme,
      shadowColor: shadow.withOpacity(0.2),
      primaryColorLight: subTitleTextColor,
      buttonColor: primary,
      hintColor: hintColor,
      primaryColorDark: primaryDark.withOpacity(0.8),
      unselectedWidgetColor: subTitleTextColor,
      disabledColor: primaryDark,
      selectedRowColor: bg,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryBg,
        contentPadding: EdgeInsets.fromLTRB(16, 0, 0, 0),
        errorStyle: subtitle2.copyWith(color: danger),
        border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
            borderSide: BorderSide.none),
        labelStyle: subtitle2,
        hintStyle: subtitle2.copyWith(color: subTitleTextColor),
      ),
      colorScheme: ColorScheme(
        primary: primary,
        onPrimary: titleProfileColor,
        primaryVariant: bgDarker,
        background: secondaryBg,
        onBackground: inputBg,
        secondary: secondary,
        onSecondary: secondaryLight,
        secondaryVariant: Colors.deepOrange,
        error: danger,
        onError: danger,
        surface: Colors.white,
        onSurface: Colors.black,
        brightness: Brightness.light,
      ));

  // TextTheme
  static final TextTheme textTheme = TextTheme(
    headline1: headline1,
    headline2: headline2,
    headline3: headline3,
    headline4: headline4,
    headline5: headline5,
    headline6: headline6,
    button: button,
    subtitle1: subtitle1,
    subtitle2: subtitle2,
    bodyText1: bodyText1,
    bodyText2: bodyText2,
  );

  // SystemUiOverlayStyle
  static final SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    /*systemNavigationBarColor: Colors.white,
    statusBarColor: headlineTextColor,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: Colors.red,
    statusBarBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,*/
    // StatusBar
    statusBarColor: headlineTextColor,
    // status bar color
    statusBarBrightness: Brightness.dark,
    //status bar brigtness
    statusBarIconBrightness: Brightness.light,
    //status barIcon Brightness
    // NavigationBar
    systemNavigationBarColor: Colors.white,
    // navigation bar color
    systemNavigationBarDividerColor: Colors.white,
    //Navigation bar divider color
    systemNavigationBarIconBrightness: Brightness.dark, //navigation bar icon
  );

  // systemUiLaunchOverlayStyle
  static final SystemUiOverlayStyle systemUiLaunchOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: headlineTextColor,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: headlineTextColor,
    systemNavigationBarDividerColor: headlineTextColor,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static final SystemUiOverlayStyle systemUiTransparentOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarDividerColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  /*
  * for Proxima Nova added height 1.4 because there is a padding with original font file that fixed with the height 1.4
  * to be
  * */
  // Text Styles
  static final TextStyle headline1 = TextStyle(
    color: Colors.white,
    fontFamily: "Proxima Nova",
    fontWeight: FontWeight.w700,
    fontSize: 32,
  );
  static final TextStyle headline2 = TextStyle(
    fontFamily: "Proxima Nova",
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 28,
  );
  static final TextStyle headline3 = TextStyle(
    color: Colors.white,
    fontFamily: "Proxima Nova",
    fontWeight: FontWeight.w700,
    fontSize: 24,
  );
  static final TextStyle headline4 = TextStyle(
    color: Colors.white,
    fontFamily: "Proxima Nova",
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );
  static final TextStyle headline5 = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w400,
    height: 1.4,
    fontFamily: "Proxima Nova",
    fontSize: 16,
  );
  static final TextStyle headline6 = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontFamily: "Proxima Nova",
    fontSize: 14,
  );

  static final TextStyle button = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontFamily: "Proxima Nova",
    fontSize: 15,
  );

  static final TextStyle subtitle1 = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontFamily: "Proxima Nova",
    fontSize: 13,
  );

  static final TextStyle subtitle2 = TextStyle(
    color: Colors.white,
    fontFamily: "Proxima Nova",
    fontWeight: FontWeight.w400,
    height: 1.4,
    fontSize: 13,
  );

  static final TextStyle bodyText1 = TextStyle(
    color: headlineTextColor,
    fontFamily: "Proxima Nova",
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );

  static final TextStyle bodyText2 = TextStyle(
    color: subTitleTextColor,
    fontFamily: "Proxima Nova",
    height: 1.4,
    fontWeight: FontWeight.w600,
    fontSize: 12,
  );

  static Color colorTweenBegin = subTitleTextColor.withOpacity(0.2);
  static Color colorTweenEnd = subTitleTextColor.withOpacity(0.6);

  //static Color colorTweenBegin2=Color(0xFFE4E7FC);
  //static Color colorTweenEnd2=Color(0xFFF1F2FE);

  static Color colorTweenBegin2 = secondaryLight;
  static Color colorTweenEnd2 = secondaryLight3.withOpacity(0.5);
}
