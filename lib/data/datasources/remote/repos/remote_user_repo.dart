import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_starter/config/messages.dart';
import 'package:flutter_starter/core/error/exceptions.dart';
import 'package:flutter_starter/data/datasources/remote/error/remote_message_error.dart';
import 'package:flutter_starter/data/models/dto/user_dto.dart';
import 'package:flutter_starter/data/models/token.dart';
import 'package:flutter_starter/data/models/university.dart';
import 'package:flutter_starter/data/models/user.dart';

abstract class RemoteUserRepo {
  // for sign up via user/signup/
  // Return User
  // Or throw HttpException if contains RemoteMessageError
  // Else throw ServerException
  Future<User> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required University university,
  });

  /*
  * activate user after sign up
  * */
  Future<User> activate({required int userId, required String code});

  Future<User> logIn({required String email, required String password});

  Future<Token> refreshToken({required String refresh});

  Future<bool> resetPassword({required String email});

  Future<bool> resendActivationCode({required int userId});

  Future<User> setForgetPassword({required String code, required String password});

  Future<User> findById({required int userId, required String accessToken, bool isPublic = false});

  Future<User> update({required int userId, UserDto? userProfile, required String accessToken});

/*Future<Pagination<User>> findAllFriends({@required PaginationDto paginationDto, @required String accessToken});

  Future<Pagination<User>> findAllAvailableUsers({@required PaginationDto paginationDto, @required String accessToken});

  Future<Pagination<User>> findAllBlockedUsers({@required PaginationDto paginationDto, @required String accessToken});

  Future<Pagination<InvitationRequest>> findAllSentRequests({@required PaginationDto paginationDto, @required String accessToken});

  Future<InvitationRequest> sentRequest({@required int userId, @required String accessToken});

  Future<InvitationRequest> findSentRequest({@required int invitationRequestId, @required String accessToken});

  Future<InvitationRequest> cancelSentRequest({@required int invitationRequestId, @required String accessToken});

  Future<Either<InvitationRequest, bool>> AcceptRejectInvitationRequest(
      {@required int invitationRequestId, @required InvitationRequestStatus invitationRequestStatus, @required String accessToken});

  Future<Pagination<InvitationRequest>> findAllReceivedRequests({@required PaginationDto paginationDto, @required String accessToken});

  Future<InvitationRequest> findReceivedRequest({@required int invitationRequestId, @required String accessToken});*/
}

@Injectable(as: RemoteUserRepo)
class RemoteUserRepoImpl implements RemoteUserRepo {
  Dio? dio;

  RemoteUserRepoImpl(this.dio);

  @override
  Future<User> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required University university,
  }) async {
    // TODO: implement signUp
    try {
      final response = await dio!.post('/user/signup/', data: {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "confirm_password": password,
        "university": university == null ? 1 : university.id,
      });

      // as Map<String,dynamic> not json string as response.body of http package
      final responseData = response.data;

      if (response.statusCode == 200) {
        final user = User.fromJson(responseData);
        return user;
      } else {
        throw DioError(response: response, requestOptions: response.requestOptions);
      }
    } on DioError catch (e) {
      //possible errors
      List<RemoteMessageError> rmerrors = [
        RemoteMessageError(code: 3, message: Messages.UNIVERSITY_MISSING),
        RemoteMessageError(code: 9, message: Messages.EMAIL_ALREADY_EXISTS),
        RemoteMessageError(code: 19, message: Messages.PASSWORD_NOT_COMPLEX),
      ];
      throw RemoteException(e: e, rmerrors: rmerrors, skipTokenException: true);
    }
  }

  @override
  Future<User> activate({
    required int userId,
    required String code,
  }) async {
    // TODO: implement activate
    try {
      final response = await dio!.put('/user/activate/$userId/', data: {
        "code": code,
      });

      final responseData = response.data;

      if (response.statusCode == 200) {
        final user = User.fromJson(responseData);
        return user;
      } else {
        throw DioError(response: response, requestOptions: response.requestOptions);
      }
    } on DioError catch (e) {
      //possible errors
      List<RemoteMessageError> rmerrors = [
        RemoteMessageError(code: 1, message: Messages.INVALID_CODE),
      ];
      throw RemoteException(e: e, rmerrors: rmerrors, skipTokenException: true);
    }
  }

  @override
  Future<Token> refreshToken({required String refresh}) async {
    // TODO: implement refreshToken
    try {
      final response = await dio!.post('/user/refresh_token/', data: {
        "refresh": refresh,
      });

      // as Map<String,dynamic> not json string as response.body of http package
      final responseData = response.data;

      if (response.statusCode == 200) {
        final token = Token.fromJson(responseData);
        return token;
      } else {
        throw DioError(response: response, requestOptions: response.requestOptions);
      }
    } on DioError catch (e) {
      final response = e.response;
      if (response?.data == null || response!.statusCode! >= 500) {
        throw ServerException();
      }
      final responseData = response.data;
      if (responseData['code'] != null) {
        var message = responseData['message'];
        if (responseData['code'] == 16) {
          message = responseData['detail'] ?? Messages.INVALID_TOKEN_OR_EXPIRED;
        }
        if (message != null) {
          final remoteMessageError = RemoteMessageError.fromJson(responseData);
          remoteMessageError.message = message;
          throw HttpException(remoteMessageError);
        } else {
          throw ServerException();
        }
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<bool> resetPassword({required String email}) async {
    // TODO: implement resetPassword
    try {
      final response = await dio!.post('/user/reset_password/', data: {
        "email": email,
      });

      // as Map<String,dynamic> not json string as response.body of http package
      if (response.statusCode == 200) {
        return true;
      } else {
        throw DioError(response: response, requestOptions: response.requestOptions);
      }
    } on DioError catch (e) {
      //possible errors
      List<RemoteMessageError> rmerrors = [
        RemoteMessageError(code: 1, message: Messages.HAS_NO_LINKED_ACCOUNT),
      ];
      throw RemoteException(e: e, rmerrors: rmerrors, skipTokenException: true);
    }
  }

  @override
  Future<bool> resendActivationCode({required int userId}) async {
    // TODO: implement resendActivationCode
    try {
      final response = await dio!.post('/user/activation_code/', data: {
        "id": userId,
      });

      // as Map<String,dynamic> not json string as response.body of http package
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  @override
  Future<User> findById({
    required int userId,
    required String accessToken,
    bool isPublic = false,
  }) async {
    // TODO: implement findById
    try {
      final path = isPublic ? '/user/public_profile/$userId/' : '/user/profile/$userId/';
      final response = await dio!.get('$path', options: Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'}));

      // as Map<String,dynamic> not json string as response.body of http package
      final responseData = response.data;

      if (response.statusCode == 200) {
        final user = User.fromJson(responseData);
        return user;
      } else {
        throw DioError(response: response, requestOptions: response.requestOptions);
      }
    } on DioError catch (e) {
      //possible errors
      List<RemoteMessageError> rmerrors = [];
      throw RemoteException(e: e, rmerrors: rmerrors);
    }
  }

  @override
  Future<User> update({int? userId, UserDto? userProfile, required String accessToken}) async {
    // TODO: implement update
    try {
      // the request required FormData as a params of the body
      FormData formData = FormData.fromMap({
        'first_name': userProfile!.firstName,
        'last_name': userProfile.lastName,
        "email": userProfile.email,
        'university': userProfile.university?.id ?? null,
        'degree': userProfile.degree,
        'current_password': userProfile.currentPassword,
        'new_password': userProfile.newPassword,
        'confirm_password': userProfile.confirmPassword,
        'profile_picture': userProfile.profilePicture != null ? await MultipartFile.fromFile(userProfile.profilePicture!.path) : null,
      });
      //filename: "${userId}${DateTime.now().toUtc()}image.txt"
      final response = await dio!.put('/user/profile/$userId/', data: formData, options: Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'}));
      // as Map<String,dynamic> not json string as response.body of http package
      final responseData = response.data;

      if (response.statusCode == 200) {
        final user = User.fromJson(responseData);
        return user;
      } else {
        throw DioError(response: response, requestOptions: response.requestOptions);
      }
    } on DioError catch (e) {
      //possible errors
      List<RemoteMessageError> rmerrors = [
        RemoteMessageError(code: 1, message: Messages.INVALID_OLD_PASSWORD),
      ];
      throw RemoteException(e: e, rmerrors: rmerrors);
    }
  }

  @override
  Future<User> logIn({required String email, required String password}) async {
    // TODO: implement logIn
    try {
      final response = await dio!.post('/user/signin/', data: {
        "email": email,
        "password": password,
      });

      // as Map<String,dynamic> not json string as response.body of http package
      final responseData = response.data;

      if (response.statusCode == 200) {
        final user = User.fromJson(responseData);
        return user;
      } else {
        throw DioError(response: response, requestOptions: response.requestOptions);
      }
    } on DioError catch (e) {
      List<RemoteMessageError> rmerrors = [
        RemoteMessageError(code: 1, message: Messages.INVALID_EMAIL_OR_PASSWORD),
      ];
      throw RemoteException(e: e, rmerrors: rmerrors, skipTokenException: true);
    }
  }

  @override
  Future<User> setForgetPassword({required String code, required String password}) async {
    // TODO: implement setForgetPassword
    try {
      final response = await dio!.post('/user/set_password/', data: {
        "code": code,
        "password": password,
        "confirm_password": password,
      });

      // as Map<String,dynamic> not json string as response.body of http package
      final responseData = response.data;

      if (response.statusCode == 200) {
        final user = User.fromJson(responseData);
        return user;
      } else {
        throw DioError(response: response, requestOptions: response.requestOptions);
      }
    } on DioError catch (e) {
      //possible errors
      List<RemoteMessageError> rmerrors = [
        RemoteMessageError(code: 1, message: Messages.INVALID_CODE),
      ];
      throw RemoteException(e: e, rmerrors: rmerrors, skipTokenException: true);
    }
  }
}
