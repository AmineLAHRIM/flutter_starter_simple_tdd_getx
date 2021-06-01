import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/config/themes/default/default_theme.dart';

class AppTheme {
  static InputDecoration inputDecoration({
    String? hintText,
    bool hasBorderSide = true,
    double radius = SizeConfig.borderRadius,
    Color? backgroundColor,
  }) {
    return InputDecoration(
        filled: true,
        fillColor: backgroundColor ?? Get.theme.colorScheme.onBackground,
        contentPadding: EdgeInsets.fromLTRB(16, 0, 0, 0),
        hintText: hintText,
        errorStyle: Get.theme.textTheme.subtitle2!.copyWith(color: Get.theme.colorScheme.error),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
          borderSide: hasBorderSide
              ? BorderSide(
                  color: Get.theme.hintColor,
                  width: SizeConfig.borderSideWidth / 2,
                )
              : BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
          borderSide: hasBorderSide
              ? BorderSide(
                  color: Get.theme.hintColor,
                  width: SizeConfig.borderSideWidth,
                )
              : BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
          borderSide: hasBorderSide
              ? BorderSide(
                  color: Get.theme.hintColor,
                  width: SizeConfig.borderSideWidth,
                )
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
          borderSide: hasBorderSide
              ? BorderSide(
                  color: Get.theme.hintColor,
                  width: SizeConfig.borderSideWidth,
                )
              : BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
          borderSide: hasBorderSide
              ? BorderSide(
                  color: Get.theme.hintColor,
                  width: SizeConfig.borderSideWidth,
                )
              : BorderSide.none,
        ),
        border: new OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
            borderSide: hasBorderSide
                ? BorderSide(
                    width: SizeConfig.borderSideWidth,
                    color: Get.theme.hintColor,
                  )
                : BorderSide.none),
        hintStyle: Get.theme.textTheme.subtitle2!.copyWith(color: Get.theme.hintColor));
  }

  static TextStyle tabTextStyle() {
    return TextStyle(
      fontFamily: "Proxima Nova",
      fontWeight: FontWeight.w600,
      fontSize: 16,
    );
  }

  static ThemeData get themeData {
    bool isDarkMode = false;
    if (isDarkMode) {
      //return DarkTheme.themeData;
    }
    return DefaultTheme.themeData;
  }

  static SystemUiOverlayStyle get systemUiOverlayStyle {
    bool isDarkMode = false;
    if (isDarkMode) {
      //return DarkTheme.systemUiOverlayStyle;
    }
    return DefaultTheme.systemUiOverlayStyle;
  }

  static SystemUiOverlayStyle get systemUiLaunchOverlayStyle {
    bool isDarkMode = false;
    if (isDarkMode) {
      //return DarkTheme.systemUiLaunchOverlayStyle;
    }
    return DefaultTheme.systemUiLaunchOverlayStyle;
  }

  static SystemUiOverlayStyle get systemUiTransparentOverlayStyle {
    bool isDarkMode = false;
    if (isDarkMode) {
      //return DarkTheme.systemUiLaunchOverlayStyle;
    }
    return DefaultTheme.systemUiTransparentOverlayStyle;
  }

  void setupLaunchSystemSettings() {
    // this will change color of status bar and system navigation bar
    SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiLaunchOverlayStyle);

    // this will prevent change oriontation
    setupPortraitMode();
  }

  void setupSystemSettings() {
    // this will change color of status bar and system navigation bar
    SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiOverlayStyle);
    // this will prevent change oriontation
    SizeConfig.isMobile ? setupPortraitMode() : setupDefaultMode();
    //setupDefaultMode();
  }

  void setupTransparentSystemSettings() {
    // this will change color of status bar and system navigation bar
    SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiTransparentOverlayStyle);
    // this will prevent change oriontation
    SizeConfig.isMobile ? setupPortraitMode() : setupDefaultMode();
    //setupDefaultMode();
  }

  // this will prevent change oriontation
  void setupPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // this will not prevent change oriontation
  void setupDefaultMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
