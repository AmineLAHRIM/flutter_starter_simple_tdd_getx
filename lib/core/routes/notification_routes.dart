/*
* Here All App Routes
* */
import 'package:equatable/equatable.dart';
import 'package:flutter_starter/core/routes/app_routes.dart';

class NotificationRoute extends Equatable {
  String? page;
  int? id;

  NotificationRoute({this.page, this.id});

  static const EVENT = 'event_id';
  static const SOCIETY = 'society_id';
  static const TICKET = 'ticket_id';
  static const INVITATION_REQUEST = 'invitation_request_id';
  static const FRIEND = 'friend_id';
  static const FRIEND_MSG = 'friend_msg_id';
  static const REFUND_ORDER = 'refund_order_id';

  static Map<String?, String> routes = {
    EVENT: AppRoutes.EVENT_DETAIL,
    SOCIETY: AppRoutes.SOCIETY_DETAIL,
    TICKET: AppRoutes.MY_TICKETS,
    //INVITATION_REQUEST: AppRoutes.FRIEND_DETAIL,
    FRIEND: AppRoutes.FRIEND_DETAIL,
    // FRIEND_MSG: AppRoutes.CHAT,
    REFUND_ORDER: AppRoutes.REFUND_PAGE,
  };

  static String? getPage({String? route}) {
    // route is EVENT for example
    if (routes.containsKey(route)) {
      return routes[route];
    } else {
      return null;
    }
  }

  @override
  // TODO: implement props
  List<Object?> get props => [page, id];

  @override
  // TODO: implement stringify
  bool get stringify => true;
}
