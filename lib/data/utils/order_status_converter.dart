import 'package:flutter_starter/data/models/enums/order_status.dart';

class OrderStatusConverter {
  static OrderStatus? fromJson({String? orderStatus}) {
    try {
      if (orderStatus != null) {
        if (orderStatus == 'PLACED SUCCESSFULLY') {
          return OrderStatus.COMPLETED;
        } else if (orderStatus == 'PENDING') {
          return OrderStatus.PENDING;
        } else if (orderStatus == 'REFUNDED') {
          return OrderStatus.REFUNDED;
        } else if (orderStatus == 'BEING PROCESSED') {
          return OrderStatus.PROCESSING;
        } else if (orderStatus == 'CANCELLED') {
          return OrderStatus.CANCELLED;
        } else if (orderStatus == 'FREE') {
          return OrderStatus.FREE;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static String? toJson({OrderStatus? orderStatus}) {
    try {
      if (orderStatus != null) {
        if (orderStatus == OrderStatus.COMPLETED) {
          return 'PLACED SUCCESSFULLY';
        } else if (orderStatus == OrderStatus.PENDING) {
          return 'PENDING';
        } else if (orderStatus == OrderStatus.REFUNDED) {
          return 'REFUNDED';
        } else if (orderStatus == OrderStatus.PROCESSING) {
          return 'BEING PROCESSED';
        } else if (orderStatus == OrderStatus.CANCELLED) {
          return 'CANCELLED';
        } else if (orderStatus == OrderStatus.FREE) {
          return 'FREE';
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
