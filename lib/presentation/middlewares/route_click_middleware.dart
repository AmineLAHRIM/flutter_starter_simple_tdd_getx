import 'package:get/get.dart';

class RouteClickMiddleware extends GetMiddleware {
  @override
  int? priority = 0;

  RouteClickMiddleware({required this.priority});

  /*@override
  RouteSettings redirect(String route) {
    Future.delayed(Duration(seconds: 1), () => Get.snackbar(" Tips ", " Please log in first APP"));
    return RouteSettings(name: route,);
  }*/

  @override
  GetPage? onPageCalled(GetPage? page) {
    //Future.delayed(Duration(seconds: 1), () => Get.snackbar(" Tips ", " Please log in first APP"));
    return page;
  }
}
