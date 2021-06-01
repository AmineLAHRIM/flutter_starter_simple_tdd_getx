import 'package:equatable/equatable.dart';
import 'package:flutter_starter/data/models/university.dart';
import 'package:flutter_starter/data/utils/dateconverter.dart';
import 'package:flutter_starter/data/utils/imagejsonconverter.dart';

class Society extends Equatable {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  String? cover;
  String? coverThumb;
  String? description;
  String? email;
  String? website;
  String? phoneNumber;
  bool? isVerified;
  bool? isDeleted;
  bool? isFollowing;
  int? owner;
  University? universityInfo;

  Society({this.id, this.createdAt, this.updatedAt, this.name, this.cover, this.coverThumb, this.description, this.email, this.website, this.phoneNumber, this.isVerified = false, this.isDeleted = false, this.isFollowing = false, this.owner});

  Society.fromJson(Map<String, dynamic> json, {bool isUtc = true, DateFormatSource? dateFormatSource}) {
    id = json['id'];
    createdAt = DateConverter.fromJson(jsonDateString: json['created_at'], isUtc: isUtc,dateFormatSource: dateFormatSource);
    updatedAt = DateConverter.fromJson(jsonDateString: json['updated_at'], isUtc: isUtc,dateFormatSource: dateFormatSource);
    name = json['name'];
    if (json['cover'] != null) cover = ImageJsonConverter.fromJson(imageUrl: json['cover']);
    if (json['cover_thumb'] != null) coverThumb = ImageJsonConverter.fromJson(imageUrl: json['cover_thumb']);
    description = json['description'];
    email = json['email'];
    website = json['website'];
    phoneNumber = json['phone_number'];
    isVerified = json['is_verified'];
    isDeleted = json['is_deleted'];
    isFollowing = json['is_following'];
    owner = json['owner'];
    universityInfo = json['university_info'] != null ? University.fromJson(json['university_info'], isUtc: isUtc,dateFormatSource: dateFormatSource) : null;
  }

  Map<String, dynamic> toJson({bool isUtc = true, DateFormatSource? dateFormatSource}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = DateConverter.toJson(date: this.createdAt, isUtc: isUtc,dateFormatSource: dateFormatSource);
    data['updated_at'] = DateConverter.toJson(date: this.updatedAt, isUtc: isUtc,dateFormatSource: dateFormatSource);
    data['name'] = this.name;
    data['cover'] = ImageJsonConverter.toJson(imageUrl: this.cover);
    data['cover_thumb'] = ImageJsonConverter.toJson(imageUrl: this.coverThumb);
    data['description'] = this.description;
    data['email'] = this.email;
    data['website'] = this.website;
    data['phone_number'] = this.phoneNumber;
    data['is_verified'] = this.isVerified;
    data['is_deleted'] = this.isDeleted;
    data['is_following'] = this.isFollowing;
    data['owner'] = this.owner;
    if (this.universityInfo != null) {
      data['university_info'] = this.universityInfo!.toJson(isUtc: isUtc,dateFormatSource: dateFormatSource);
    }
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        name,
        cover,
        coverThumb,
        description,
        email,
        website,
        phoneNumber,
        isVerified,
        isDeleted,
        owner,
      ];
}
