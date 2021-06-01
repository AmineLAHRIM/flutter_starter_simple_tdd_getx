import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter/config/di/injection.dart';
import 'package:flutter_starter/core/loading/loading_state.dart';
import 'package:flutter_starter/presentation/pages/home_page/home.controller.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(getIt<HomeController>());

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
              color: Colors.amberAccent,
            ),
            Obx(() {
              // only Obx will rebuild when userProfileState change not the whole home page widget
              var userProfileState = controller.userProfileState.value;
              if (userProfileState is LOADING) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.amberAccent,
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    'Here a Reactive Widget LOADING',
                    style: TextStyle(color: Colors.white,fontSize: 20),

                  ),
                );
              } else if (userProfileState is LOADED) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.amberAccent,
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    'Here a Reactive Widget LOADED',
                    style: TextStyle(color: Colors.white,fontSize: 20),

                  ),
                );
              } else if (userProfileState is ERROR) {
                var message = userProfileState.message;
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.amberAccent,
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    'Here a Reactive Widget ERROR with message ${message}',
                    style: TextStyle(color: Colors.white,fontSize: 20),

                  ),
                );
              } else if (userProfileState is EMPTY) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.amberAccent,
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    'Here a Reactive Widget EMPTY',
                    style: TextStyle(color: Colors.white,fontSize: 20),
                  ),
                );
              }

              return Container();
            }),
          ],
        ),
      ),
    );
  }
}
