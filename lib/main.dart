import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:flutter_starter/config/constant.dart';
import 'package:flutter_starter/config/di/injection.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/config/themes/app_theme.dart';
import 'package:flutter_starter/core/routes/app_routes.dart';
import 'package:flutter_starter/services/notification_service.dart';

void main() async {
  /*WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final route = await setupLaunch();
  runApp(MyApp(initialRoute: route));*/

  /*WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();*/
  WidgetsFlutterBinding.ensureInitialized();
  //await configureDependencies();
  // FCM App in Background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //Handle ForgroundNotification From App Closed
  NotificationService.initOpenForgroundNotifcationAppClosed();
  /*final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final NotificationAppLaunchDetails notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  print('handleOpenForgroundNotifcationAppClosed didNotificationLaunchApp ${notificationAppLaunchDetails.didNotificationLaunchApp}');
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
   Constant.selectedNotificationPayload=notificationAppLaunchDetails.payload;
  }*/
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:

  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        // init sizes
        SizeConfig().init(constraints, orientation);
        // Setup Theme for the Launch
        AppTheme().setupLaunchSystemSettings();

        // App
        return GestureDetector(
          onTap: () async {
            await Future.delayed(Constant.DURATION_CLICK);

            WidgetsBinding.instance!.focusManager.primaryFocus?.unfocus();
          },
          child: GetMaterialApp(
            smartManagement: SmartManagement.full,
            theme: AppTheme.themeData,
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.SPLASH,
            getPages: AppRoutes.pages,
          ),
        );
      });
    });
  }
}

/*Future<String> setupLaunch() async {
  final authService = Get.put(getIt<AuthService>());
  if (await authService.isLogged()) {
    //Get.offNamed(AppRoutes.HOME);
    return AppRoutes.HOME;
    //return Future.value(new HomePage());
  } else {
    return AppRoutes.LOGIN;
    //Get.offNamed(AppRoutes.LOGIN);
    //return Future.value(new LoginPage());
  }
  */ /* return Future.delayed(Duration(seconds: 3), () async {

  });*/ /*
}*/
