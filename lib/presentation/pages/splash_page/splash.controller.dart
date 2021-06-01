import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_starter/config/constant.dart';
import 'package:flutter_starter/config/di/injection.dart';
import 'package:flutter_starter/core/routes/app_routes.dart';
import 'package:flutter_starter/services/auth_service.dart';
import 'package:flutter_starter/services/firebase_remote_config_service.dart';

class SplashController extends GetxController {
  final DateTime beginLaunchDate = DateTime.now();
  late DateTime endLaunchDate;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    WidgetsFlutterBinding.ensureInitialized();
    await configureDependencies();
    await Firebase.initializeApp();
    await setupFirebaseRemoteConfig();
    await _initGoogleMobileAds();
    await _initHive();
    setupLaunch();
  }

  Future<void> setupLaunch() async {
    try {
      endLaunchDate = DateTime.now();
      final diffDate = endLaunchDate.difference(beginLaunchDate);
      print('init diffDate=${diffDate}');
      // return 0 if equal or positif if diffDate highter
      if (diffDate.compareTo(Constant.DURATION_SPLASH) >= 0) {
        print('if diffDate=${diffDate}');
        _initApp();
      } else {
        final deltaDur = Constant.DURATION_SPLASH - diffDate;
        print('else diffDate=${diffDate} endLaunchDate=${endLaunchDate} deltaDur=${deltaDur}');
        Future.delayed(deltaDur, () async {
          _initApp();
        });
      }
    } catch (e) {
      Future.delayed(Duration(seconds: 2), () async {
        _initApp();
      });
    }
  }

  Future<void> _initApp() async {
    // COMPLETE: Initialize Google Mobile Ads SDK
    AuthService authService = getIt<AuthService>();
    Get.offNamed(AppRoutes.HOME);


    /*if (await authService.isLogged()) {
      Get.offNamed(AppRoutes.HOME);
    } else {
      Get.offNamed(AppRoutes.LOGIN);
    }*/
  }

  Future<void> _initHive() async {
    Hive.initFlutter();
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    // COMPLETE: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  Future<void> setupFirebaseRemoteConfig() async {
    FirebaseRemoteConfigService firebaseRemoteConfigService = getIt<FirebaseRemoteConfigService>();
    await firebaseRemoteConfigService.initialize();
  }
}
