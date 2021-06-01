import 'package:equatable/equatable.dart';
import 'package:flutter_starter/data/utils/dateconverter.dart';
import 'package:flutter_starter/data/utils/imagejsonconverter.dart';

class University extends Equatable {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? address;
  String? country;
  String? city;
  String? point;
  String? name;
  String? description;
  String? photo;

  University({this.id, this.createdAt, this.updatedAt, this.address, this.country, this.city, this.point, this.name, this.description, this.photo});

  University.fromJson(Map<String, dynamic> json, {bool isUtc = true, DateFormatSource? dateFormatSource}) {
    id = json['id'];
    createdAt = DateConverter.fromJson(jsonDateString: json['created_at'], isUtc: isUtc,dateFormatSource: dateFormatSource);
    updatedAt = DateConverter.fromJson(jsonDateString: json['updated_at'], isUtc: isUtc,dateFormatSource: dateFormatSource);
    address = json['address'];
    country = json['country'];
    city = json['city'];
    point = json['point'];
    name = json['name'];
    description = json['description'];
    if (json['photo'] != null) photo = ImageJsonConverter.fromJson(imageUrl: json['photo']);
  }

  Map<String, dynamic> toJson({bool isUtc = true, DateFormatSource? dateFormatSource}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = DateConverter.toJson(date: this.createdAt, isUtc: isUtc,dateFormatSource: dateFormatSource);
    data['updated_at'] = DateConverter.toJson(date: this.updatedAt, isUtc: isUtc,dateFormatSource: dateFormatSource);
    data['address'] = this.address;
    data['country'] = this.country;
    data['city'] = this.city;
    data['point'] = this.point;
    data['name'] = this.name;
    data['description'] = this.description;
    data['photo'] = ImageJsonConverter.toJson(imageUrl: this.photo);
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        address,
        country,
        city,
        point,
        name,
        description,
        photo,
      ];
}
