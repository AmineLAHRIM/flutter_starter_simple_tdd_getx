import 'package:equatable/equatable.dart';
import 'package:flutter_starter/data/models/enums/friend_status.dart';
import 'package:flutter_starter/data/models/university.dart';
import 'package:flutter_starter/data/utils/dateconverter.dart';
import 'package:flutter_starter/data/utils/imagejsonconverter.dart';

class User extends Equatable {
  int? id;
  University? university;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? phoneNumber;
  String? profilePicture;
  String? profilePictureThumb;
  String? firstName;
  String? lastName;
  String? degree;
  String? email;
  String? refresh;
  String? access;
  DateTime? accessExpiryAt;
  DateTime? refreshExpiryAt;

  FriendStatus? friendStatus;

  User({this.id, this.university, this.createdAt, this.updatedAt, this.phoneNumber, this.profilePicture, this.profilePictureThumb, this.firstName, this.lastName, this.degree, this.email, this.refresh, this.access, this.accessExpiryAt, this.refreshExpiryAt});

  User.fromJson(Map<String, dynamic> json, {bool isUtc = true, DateFormatSource? dateFormatSource}) {
    id = json['id'];
    university = json['university_info'] != null ? new University.fromJson(json['university_info']) : null;
    createdAt = DateConverter.fromJson(jsonDateString: json['created_at'], isUtc: isUtc, dateFormatSource: dateFormatSource);
    updatedAt = DateConverter.fromJson(jsonDateString: json['updated_at'], isUtc: isUtc, dateFormatSource: dateFormatSource);
    phoneNumber = json['phone_number'];
    if (json['profile_picture'] != null) profilePicture = ImageJsonConverter.fromJson(imageUrl: json['profile_picture']);
    if (json['profile_picture_thumb'] != null) profilePictureThumb = ImageJsonConverter.fromJson(imageUrl: json['profile_picture_thumb']);
    firstName = json['first_name'];
    lastName = json['last_name'];
    degree = json['degree'];
    email = json['email'];
    refresh = json['refresh'];
    access = json['access'];
    accessExpiryAt = DateConverter.fromJson(jsonDateString: json['access_expiry_at'], isUtc: isUtc, dateFormatSource: dateFormatSource);
    refreshExpiryAt = DateConverter.fromJson(jsonDateString: json['refresh_expiry_at'], isUtc: isUtc, dateFormatSource: dateFormatSource);
  }

  Map<String, dynamic> toJson({bool isUtc = true, DateFormatSource? dateFormatSource}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.university != null) {
      data['university_info'] = this.university!.toJson();
    }
    data['created_at'] = DateConverter.toJson(date: this.createdAt, isUtc: isUtc, dateFormatSource: dateFormatSource);
    data['updated_at'] = DateConverter.toJson(date: this.updatedAt, isUtc: isUtc, dateFormatSource: dateFormatSource);
    data['profile_picture'] = ImageJsonConverter.toJson(imageUrl: this.profilePicture);
    data['profile_picture_thumb'] = ImageJsonConverter.toJson(imageUrl: this.profilePictureThumb);
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    //data['degree'] = this.degree;
    data['email'] = this.email;
    data['refresh'] = this.refresh;
    data['access'] = this.access;
    data['access_expiry_at'] = DateConverter.toJson(date: this.accessExpiryAt, isUtc: isUtc, dateFormatSource: dateFormatSource);
    data['refresh_expiry_at'] = DateConverter.toJson(date: this.refreshExpiryAt, isUtc: isUtc, dateFormatSource: dateFormatSource);
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, university, createdAt, updatedAt, phoneNumber, profilePicture, profilePictureThumb, firstName, lastName, degree, email, refresh, access, accessExpiryAt, refreshExpiryAt];
}
