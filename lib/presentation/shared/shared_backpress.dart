import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/presentation/shared/shared_alert_dialog.dart';

class SharedBackPress {
  static Future<bool> onBackPressed(BuildContext context) async {
    var dialog = SharedAlertDialog(
        title: "Exit the app",
        message: "Are you sure do you want to exit the app ?",
        onPostivePressed: () {
          Get.back(result: true);
        },
        onNegativePressed: () {
          Get.back(result: false);
        },
        positiveColortext: Get.theme.colorScheme.error,
        //negativeColortext: Get.theme.buttonColor,
        positiveBtnText: 'Exit',
        negativeBtnText: 'Cancel');
    final result = await Get.dialog(dialog) as bool?;
    return result ?? false;
    /*final result =  Get.dialog(dialog) as Future<bool>?;
    return result ?? Future.value(false);*/
  }
}
