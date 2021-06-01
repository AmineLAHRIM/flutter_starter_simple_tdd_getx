import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:flutter_starter/config/size_config.dart';

class Constant {
  Constant();

  // REST API CONFIG
  static var HOST_URL = 'URL_HERE';

  static String get REMOTE_URL => HOST_URL + '/api';

  static String get SUCCESS_URL => HOST_URL + '/api/user/stripe/success?session_id={CHECKOUT_SESSION_ID}';

  static String get FAILURE_URL => HOST_URL + '/api/user/stripe/cancelled/';

  static String get INITIAL_URL => HOST_URL + '/api/user/stripe/initial/';

  static Map<String, String> GOOGLE_APPLICATION_CREDENTIALS = {
    "private_key_id": "929eab74006***********",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMII*******Ag5g\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-rdtji@*******.iam.gserviceaccount.com",
    "client_id": "************.apps.googleusercontent.com",
    "type": "service_account"
  };
  static List<String> GOOGLE_APPLICATION_FCM_SCOPES = [
    'https://www.googleapis.com/auth/cloud-platform.read-only',
    'https://www.googleapis.com/auth/firebase.messaging',
  ];

  static String get MAP_URL {
    if (GetPlatform.isAndroid) {
      return 'https://www.google.com/maps/place/';
    } else if (GetPlatform.isIOS) {
      return 'https://maps.apple.com/?daddr=';
    } else {
      return 'https://www.google.com/maps/place/';
    }
  }

  static var NATIVE_AD_ID = NativeAd.testAdUnitId;

  static String? openedNotificationPayload;

  static const Duration TO_NEXT_PAGE_DURATION = Duration(seconds: 2);
  static const Duration ANIMTAION_DURATION = Duration(milliseconds: 700);
  static const Duration LONG_ANIMTAION_DURATION = Duration(seconds: 1);
  static const Duration DURATION_EVENT_COUNTDOWN = Duration(days: 20);
  static const Duration ANIMTAION_SCALE = Duration(seconds: 8);
  static const Duration FAST_ANIMTAION_DURATION = Duration(milliseconds: 500);
  static const Duration SLOW_ANIMTAION_DURATION = Duration(seconds: 1, milliseconds: 500);
  static const Duration DURATION_CLICK = Duration(milliseconds: 300);
  static const Duration DURATION_SPLASH = Duration(seconds: 1, milliseconds: 300);

  // DURATION FOR ENTRY ANIMATIONS
  static const int DURATION_MILI = 200;
  static const Duration DURATION1 = Duration(milliseconds: DURATION_MILI);
  static const Duration DURATION2 = Duration(milliseconds: DURATION_MILI * 2);
  static const Duration DURATION3 = Duration(milliseconds: DURATION_MILI * 3);
  static const Duration DURATION4 = Duration(milliseconds: DURATION_MILI * 4);
  static const Duration DURATION5 = Duration(milliseconds: DURATION_MILI * 5);
  static const Duration DURATION6 = Duration(milliseconds: DURATION_MILI * 6);
  static const Duration DURATION7 = Duration(milliseconds: DURATION_MILI * 7);

  static const double SNACK_BAR_OPACITY = 0.8;
  static const int MAX_SEND_CODE = 3;
  static const int LIST_PAGE_SIZE = 12;
  static const double ENTRY_YOFFSET = 30;
  static const double ENTRY_YOFFSET_LIST = 60;
  static const double KM_TO_MILE_FACTOR = 0.621371;
  static const String DEFAULT_CURRENCY = 'gbp';
  static const String DEFAULT_CURRENCY_TEXT = '£';
  static final DateFormat backendDateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
  static final DateFormat firebaseDateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

  //static const bool ENABLE_ADS = true;
  static var NEXT_INDEX_DIFF_TO_SHOW_NATIVE_AD = 4;

  static int get INDEX_EACH_NATIVE_ADS_TO_SHOW => SizeConfig.isMobile ? NEXT_INDEX_DIFF_TO_SHOW_NATIVE_AD + 1 : 8;

  static var ENABLE_ADS_MOBILE = true;

  static bool get ENABLE_ADS => SizeConfig.isMobile ? ENABLE_ADS_MOBILE : false;

  static int get FOLLOWERS_MAX_SIZE => SizeConfig.isMobile ? 5 : 8;

  static int get FOLLOWED_SOCIETIES_MAX_SIZE => SizeConfig.isMobile ? 5 : 8;

  // or new Dio with a BaseOptions instance.
  static final BaseOptions options = new BaseOptions(
    baseUrl: REMOTE_URL,
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );

  // here a stripe secret test key
  static var STRIPE_SECRET_KEY = 'sk_test_51IJkXbFoxTXvuBgPxnDWcmixd8RqxqhtvbAoruEE6hvoTMwPKhDLJ7j0Wbbd7LVD7Ss53ZxDNl5ARk30Z1BeUhyd00RI6IRY7N';
}
