import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_starter/data/models/university.dart';

class UserDto extends Equatable {
  String? firstName;
  String? lastName;
  String? email;
  String? currentPassword;
  String? newPassword;
  String? confirmPassword;
  University? university;
  String? degree;
  File? profilePicture;

  UserDto({
    this.firstName,
    this.lastName,
    this.email,
    this.currentPassword,
    this.newPassword,
    this.confirmPassword,
    this.university,
    this.degree,
    this.profilePicture,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [firstName, lastName, email, currentPassword, newPassword, confirmPassword, university, degree, profilePicture];
}
