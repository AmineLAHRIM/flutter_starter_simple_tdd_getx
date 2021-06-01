import 'package:flutter_starter/config/constant.dart';

extension DoubleExtension on num {
  String? get currencyPrice {
    if (this != null) {
      if (this > 0) {
        return "${currency + this.toStringAsFixed(2)}";
      } else {
        return 'FREE';
      }
    }
    return null;
  }

  String get currency {
    return '${Constant.DEFAULT_CURRENCY_TEXT}';
  }
}
