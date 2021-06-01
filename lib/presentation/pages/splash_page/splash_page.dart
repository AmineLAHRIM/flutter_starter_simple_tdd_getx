import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/presentation/pages/splash_page/splash.controller.dart';

class SplashPage extends StatelessWidget {
  final controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Get.theme.backgroundColor,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.blue,
              alignment: Alignment.center,
              child: AutoSizeText(
                'Here a starter Project Splash Page',
                style: TextStyle(color: Colors.white,fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
