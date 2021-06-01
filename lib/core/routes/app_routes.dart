/*
* Here All App Routes
* */
import 'package:get/get.dart';
import 'package:flutter_starter/presentation/pages/home_page/home_page.dart';
import 'package:flutter_starter/presentation/pages/login_page/login_page.dart';
import 'package:flutter_starter/presentation/pages/splash_page/splash_page.dart';

class AppRoutes {
  static const SIGNUP = '/signup_page';
  static const SPLASH = '/splash_page';
  static const ACTIVATE = '/activate_page';
  static const LOGIN = '/login_page';
  static const HOME = '/home_page';
  static const REST_PASSWORD = '/reset_password_page';
  static const SET_PASSWORD = '/set_password_page';
  static const CHANGE_PROFILE_INFO = '/change_profile_info_page';
  static const CHANGE_PASSWORD = '/change_password_page';
  static const EVENT_DETAIL = '/event_detail_page';
  static const TICKET_SELECT = '/ticket_select_page';
  static const STRIPE_CHECKOUT = '/stripe_checkout_page';
  static const MY_TICKETS = '/my_tickets_page';
  static const SOCIETY_DETAIL = '/society_detail_page';
  static const NEWS_PAGE = '/news_page';
  static const REFUND_PAGE = '/refund_page';
  static const FRIEND_DETAIL = '/friend_page';
  static const PROFILE_DETAIL = '/profile_detail_page';

  static List<GetPage> pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashPage(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.HOME,
      transition: Transition.cupertino,
      page: () => HomePage(),
    ),
  ];
}
