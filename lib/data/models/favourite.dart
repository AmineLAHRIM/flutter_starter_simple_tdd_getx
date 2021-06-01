import 'package:equatable/equatable.dart';
import 'package:flutter_starter/data/utils/dateconverter.dart';

class Favourite extends Equatable {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? event;
  int? lunaUser;

  Favourite({this.id, this.createdAt, this.updatedAt, this.event, this.lunaUser});

  Favourite.fromJson(Map<String, dynamic> json, {bool isUtc = true, DateFormatSource? dateFormatSource}) {
    id = json['id'];
    createdAt = DateConverter.fromJson(jsonDateString: json['created_at'], isUtc: isUtc,dateFormatSource: dateFormatSource);
    updatedAt = DateConverter.fromJson(jsonDateString: json['updated_at'], isUtc: isUtc,dateFormatSource: dateFormatSource);
    event = json['event'];
    lunaUser = json['luna_user'];
  }

  Map<String, dynamic> toJson({bool isUtc = true, DateFormatSource? dateFormatSource}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = DateConverter.toJson(date: this.createdAt, isUtc: isUtc,dateFormatSource: dateFormatSource);
    data['updated_at'] = DateConverter.toJson(date: this.updatedAt, isUtc: isUtc,dateFormatSource: dateFormatSource);
    data['event'] = this.event;
    data['luna_user'] = this.lunaUser;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, createdAt, updatedAt, event, lunaUser];
}
