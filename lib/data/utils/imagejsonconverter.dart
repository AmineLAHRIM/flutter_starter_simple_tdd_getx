import 'package:flutter_starter/config/constant.dart';

class ImageJsonConverter {
  static String? fromJson({String? imageUrl}) {
    try {
      if (imageUrl != null && imageUrl.isNotEmpty) {
        return Constant.HOST_URL + imageUrl;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static String? toJson({String? imageUrl}) {
    try {
      if (imageUrl != null && imageUrl.isNotEmpty && imageUrl.contains(Constant.HOST_URL)) {
        return imageUrl.replaceFirst(Constant.HOST_URL, '');
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
