import 'package:dartz/dartz.dart';
import 'package:flutter_starter/core/error/failures.dart';
import 'package:flutter_starter/data/models/dto/user_dto.dart';
import 'package:flutter_starter/data/models/enums/data_source.dart';
import 'package:flutter_starter/data/models/university.dart';
import 'package:flutter_starter/data/models/user.dart';

abstract class UserRepo {
  Future<Either<Failure, User>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required University university,
  });

  Future<Either<Failure, User>> activate({required String code});

  Future<bool> isRegistred();

  Future<bool> isLogged();

  Future<Either<Failure, User>> logIn({required String email, required String password});

  Future<Either<Failure, bool>> resetPassword({required String email});

  Future<bool> resendActivationCode();

  Future<Either<Failure, User>> setForgetPassword({required String code, required String password});

  Future<Either<Failure, User?>> getUser({DataSource dataSource = DataSource.REMOTE});

  Future<Either<Failure, User>> getPublicUser({
    required int userId,
  });

  Future<bool> logout();

  Future<Either<Failure, User>> updateUser({UserDto? userProfile});

  Future<bool> hasNewFriend(bool value);

  Future<bool> hasNewMessage(bool value);
}
