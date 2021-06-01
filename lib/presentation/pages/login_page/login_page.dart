import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  //final controller = Get.put(LoginController());

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
              color: Colors.greenAccent,
              alignment: Alignment.center,
              child: AutoSizeText(
                'Here a starter Project Login Page',
                style: TextStyle(color: Colors.white,fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
