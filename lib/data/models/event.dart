import 'package:equatable/equatable.dart';
import 'package:flutter_starter/data/models/category.dart';
import 'package:flutter_starter/data/models/custom_native_ad.dart';
import 'package:flutter_starter/data/models/event_type.dart';
import 'package:flutter_starter/data/models/society.dart';
import 'package:flutter_starter/data/models/ticket_type.dart';
import 'package:flutter_starter/data/utils/dateconverter.dart';
import 'package:flutter_starter/data/utils/imagejsonconverter.dart';
import 'package:uuid/uuid.dart';

class Event extends Equatable {
  int? id;
  EventType? eventTypeInfo;
  List<TicketType>? ticketTypes;
  Category? categoryInfo;
  Society? societyInfo;
  double? distance;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? address;
  String? country;
  String? city;
  String? point;
  String? name;
  DateTime? startDate;
  DateTime? endDate;
  String? photo;
  String? banner;
  String? ticketLink;
  String? description;
  String? videoLink;
  bool? isRefundable;
  bool? isFavorite;
  bool? isAttending;
  int? category;
  int? eventType;
  int? society;

  // for ads purpose
  String? adId;
  bool isAdLoaded = false;
  bool isAdsItem = false;
  bool isAdLoading = false;
  CustomNativeAd? customNativeAd;

  // for styling purpose
  //Color dominantColor;

  Event({
    this.id,
    this.categoryInfo,
    this.societyInfo,
    this.eventTypeInfo,
    this.ticketTypes,
    this.distance,
    this.createdAt,
    this.updatedAt,
    this.address,
    this.country,
    this.city,
    this.point,
    this.name,
    this.startDate,
    this.endDate,
    this.photo,
    this.banner,
    this.ticketLink,
    this.description,
    this.videoLink,
    this.isRefundable,
    this.isFavorite,
    this.isAttending,
    this.category,
    this.eventType,
    this.society,
    this.isAdLoaded = false,
    this.isAdsItem = false,
    this.isAdLoading = false,
    this.adId,
    this.customNativeAd,
  });

  Event.fromJson(Map<String, dynamic> json, {bool isUtc = true, DateFormatSource? dateFormatSource}) {
    id = json['id'];
    categoryInfo = json['category_info'] != null ? new Category.fromJson(json['category_info']) : null;
    eventTypeInfo = json['event_type_info'] != null ? new EventType.fromJson(json['event_type_info']) : null;
    societyInfo = json['society_info'] != null ? new Society.fromJson(json['society_info']) : null;

    if (json['ticket_types'] != null) {
      ticketTypes = [];
      json['ticket_types'].forEach((v) {
        ticketTypes!.add(TicketType.fromJson(v, isUtc: isUtc,dateFormatSource: dateFormatSource));
      });
    }
    distance = json['distance'];
    createdAt = DateConverter.fromJson(jsonDateString: json['created_at'], isUtc: isUtc,dateFormatSource: dateFormatSource);
    updatedAt = DateConverter.fromJson(jsonDateString: json['updated_at'], isUtc: isUtc,dateFormatSource: dateFormatSource);
    address = json['address'];
    country = json['country'];
    city = json['city'];
    point = json['point'];
    name = json['name'];
    startDate = DateConverter.fromJson(jsonDateString: json['start_date'], isUtc: isUtc,dateFormatSource: dateFormatSource);
    endDate = DateConverter.fromJson(jsonDateString: json['end_date'], isUtc: isUtc,dateFormatSource: dateFormatSource);
    if (json['photo'] != null) photo = ImageJsonConverter.fromJson(imageUrl: json['photo']);
    banner = json['banner'];
    ticketLink = json['ticket_link'];
    description = json['description'];
    videoLink = json['video_link'];
    isRefundable = json['is_refundable'] ?? false;
    isFavorite = json['is_favorite'] ?? false;
    isAttending = json['is_attending'] ?? false;
    category = json['category'];
//eventType = json['event_type'] != null ? new EventType.fromJson(json['event_type']) : null;
    eventType = json['event_type'];
    society = json['society'];
  }

  Map<String, dynamic> toJson({bool isUtc = true, DateFormatSource? dateFormatSource}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.categoryInfo != null) {
      data['category_info'] = this.categoryInfo!.toJson();
    }
    if (this.societyInfo != null) {
      data['society_info'] = this.societyInfo!.toJson();
    }
    if (this.eventTypeInfo != null) {
      data['event_type_info'] = this.eventTypeInfo!.toJson();
    }
    if (this.ticketTypes != null) {
      data['ticket_types'] = this.ticketTypes!.map((v) => v.toJson()).toList();
    }
    data['distance'] = this.distance;
    data['created_at'] = DateConverter.toJson(date: this.createdAt, isUtc: isUtc,dateFormatSource: dateFormatSource);
    data['updated_at'] = DateConverter.toJson(date: this.updatedAt, isUtc: isUtc,dateFormatSource: dateFormatSource);
    data['address'] = this.address;
    data['country'] = this.country;
    data['city'] = this.city;
    data['point'] = this.point;
    data['name'] = this.name;
    data['start_date'] = DateConverter.toJson(date: this.startDate, isUtc: isUtc,dateFormatSource: dateFormatSource);
    data['end_date'] = DateConverter.toJson(date: this.endDate, isUtc: isUtc,dateFormatSource: dateFormatSource);
    data['photo'] = ImageJsonConverter.toJson(imageUrl: this.photo);
    data['banner'] = this.banner;
    data['ticket_link'] = this.ticketLink;
    data['description'] = this.description;
    data['video_link'] = this.videoLink;
    data['is_refundable'] = this.isRefundable;
    data['is_favorite'] = this.isFavorite;
    data['is_attending'] = this.isAttending;
    data['category'] = this.category;
    data['event_type'] = this.eventType;
    /*if (this.eventType != null) {
      data['event_type'] = this.eventType.toJson();
    }*/
    data['society'] = this.society;
    return data;
  }

  @override
// TODO: implement props
  List<Object?> get props => [
        id,
        categoryInfo,
        societyInfo,
        eventTypeInfo,
        ticketTypes,
        distance,
        createdAt,
        updatedAt,
        address,
        country,
        city,
        point,
        name,
        startDate,
        endDate,
        photo,
        banner,
        ticketLink,
        description,
        videoLink,
        isRefundable,
        isFavorite,
        isAttending,
        category,
        eventType,
        society,
      ];
}
