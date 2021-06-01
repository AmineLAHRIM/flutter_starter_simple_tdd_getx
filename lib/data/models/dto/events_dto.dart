import 'package:equatable/equatable.dart';
import 'package:flutter_starter/config/constant.dart';

class EventsDto extends Equatable {
  int? page;
  int pageSize;
  bool isFollowed;
  bool isAsc;
  bool isFavourite;
  bool isAttending;
  String? sortBy;
  String? text;
  int? society;
  int? university;
  DateTime? startDateLte;
  DateTime? startDateGte;
  DateTime? endDateLte;
  DateTime? endDateGte;
  double? latitude;
  double? longitude;
  double? distance;
  bool upcoming;
  bool old;

  // have 1 'Standard' or 2 'Online'
  int? eventType;

  EventsDto({
    this.page = 1,
    this.pageSize = Constant.LIST_PAGE_SIZE,
    this.isFollowed = false,
    this.isAsc = false,
    this.isFavourite = false,
    this.isAttending = false,
    this.sortBy,
    this.text,
    this.society,
    this.university,
    this.startDateLte,
    this.startDateGte,
    this.endDateGte,
    this.endDateLte,
    this.latitude,
    this.longitude,
    this.distance,
    this.upcoming = false,
    this.old = false,
    this.eventType,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        page,
        pageSize,
        isFollowed,
        isAsc,
        isFavourite,
        isAttending,
        sortBy,
        text,
        society,
        university,
        startDateLte,
        startDateGte,
        endDateLte,
        endDateGte,
        latitude,
        longitude,
        distance,
        upcoming,
        old,
        eventType,
      ];

  @override
  bool get stringify {
    return true;
  }
}
