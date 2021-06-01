import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_starter/config/messages.dart';
import 'package:flutter_starter/core/error/exceptions.dart';
import 'package:flutter_starter/core/error/failures.dart';
import 'package:flutter_starter/core/network/network_info.dart';
import 'package:flutter_starter/data/datasources/local/repos/local_user_repo.dart';
import 'package:flutter_starter/data/datasources/remote/repos/remote_user_repo.dart';
import 'package:flutter_starter/data/models/dto/user_dto.dart';
import 'package:flutter_starter/data/models/enums/data_source.dart';
import 'package:flutter_starter/data/models/university.dart';
import 'package:flutter_starter/data/models/user.dart';
import 'package:flutter_starter/data/repos/abstract/user_repo.dart';

@Injectable(as: UserRepo)
class UserRepoImpl implements UserRepo {
  NetworkInfo? networkInfo;
  LocalUserRepo? localUserRepo;
  RemoteUserRepo? remoteUserRepo;

  UserRepoImpl({this.networkInfo, this.localUserRepo, this.remoteUserRepo});

  @override
  Future<Either<Failure, User>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required University university,
  }) async {
    // TODO: implement signUp
    if (await networkInfo!.isConnected) {
      try {
        final remoteUser = await this.remoteUserRepo!.signUp(firstName: firstName, lastName: lastName, email: email, password: password, university: university);
        await localUserRepo!.cache(remoteUser);
        return Right(remoteUser);
      } on HttpException catch (httpException) {
        return Left(HttpFailure(httpException.remoteMessageError));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // TODO: implement local user repo
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<bool> isActivated() async {
    // TODO: implement isActivated
    throw UnimplementedError();
  }

  @override
  Future<bool> isLogged() async {
    // TODO: implement isSignIn
    final localUser = this.localUserRepo!.findCachedUser();
    if (localUser == null) return false;

    if (localUser.access != null && localUser.accessExpiryAt != null) {
      print('before isValidToken localUser EXIST');
      return isValidToken(localUser: localUser);
    } else {
      print('before isValidToken localUser NOT EXIST');
      return false;
    }
  }

  @override
  Future<bool> isRegistred() async {
    // TODO: implement isSignUp
    final localUser = this.localUserRepo!.findCachedUser();
    return localUser != null ? true : false;
  }

  @override
  Future<Either<Failure, User>> logIn({required String email, required String password}) async {
    // TODO: implement logIn
    if (await networkInfo!.isConnected) {
      try {
        final remoteUser = await this.remoteUserRepo!.logIn(email: email, password: password);
        await localUserRepo!.cache(remoteUser);
        return Right(remoteUser);
      } on HttpException catch (httpException) {
        return Left(HttpFailure(httpException.remoteMessageError));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // TODO: implement local user repo
      return Left(ConnectionFailure());
    }
  }

  Future<bool> isValidToken({required User localUser}) async {
    //var inputFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    var dateNow = DateTime.now();
    if (localUser.id == null) return Future.value(false);

    //final accessExpiryAtDate = inputFormat.par (localUser.accessExpiryAt);
    if (await networkInfo!.isConnected) {
      if (localUser.accessExpiryAt!.isAfter(dateNow)) {
        var remoteUser;
        try {
          remoteUser = await this.remoteUserRepo!.findById(userId: localUser.id!, accessToken: localUser.access!);
        } on HttpException {
          // when return the [RemoteMessageError] from the server
          return false;
        } on ServerException {
          // enter to home first then is connection come back and from any request if is not logged in then redirect to login page
          return true;
        } on TokenException {
          return false;
        }
        return remoteUser != null ? true : false;
      } else {
        if (localUser.refresh != null && localUser.refreshExpiryAt != null) {
          final refreshExpiryAtDate = localUser.refreshExpiryAt!;
          if (refreshExpiryAtDate.isAfter(dateNow)) {
            try {
              print('[TokenFailure] token refresh BECAUSE accessExpiryAt=${localUser.accessExpiryAt} | refreshExpiryAt=${refreshExpiryAtDate} | DateTimeNow=${dateNow}');
              final token = await remoteUserRepo!.refreshToken(refresh: localUser.refresh!);
              localUser.access = token.access;
              localUser.accessExpiryAt = token.accessExpiryAt;
              localUser.refresh = token.refresh;
              localUser.refreshExpiryAt = token.refreshExpiryAt;
              await localUserRepo!.cache(localUser);
              print('[TokenFailure] token refreshed WITH accessExpiryAt=${localUser.accessExpiryAt} | refreshExpiryAt=${localUser.refreshExpiryAt} | DateTimeNow=${dateNow}');

              return true;
            } on HttpException catch (httpException) {
              // when return the [RemoteMessageError] from the server
              return false;
            } on ServerException {
              // enter to home first then is connection come back and from any request if is not logged in then redirect to login page
              return true;
            }
          } else {
            print('isValidToken false refresh is EXPIRED ' + refreshExpiryAtDate.toString() + " NOW= " + dateNow.toString());
            return Future.value(false);
          }
        } else {
          print('isValidToken false refresh is NOT EXIST');
          return Future.value(false);
        }
      }
    } else {
      // enter to home first then is connection come back and from any request if is not logged in then redirect to login page
      return Future.value(true);
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword({required String email}) async {
    // TODO: implement resetPassword
    if (await networkInfo!.isConnected) {
      try {
        final isResetted = await this.remoteUserRepo!.resetPassword(email: email);
        return Right(isResetted);
      } on HttpException catch (httpException) {
        return Left(HttpFailure(httpException.remoteMessageError));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // TODO: implement local user repo
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<bool> resendActivationCode() async {
    if (await networkInfo!.isConnected) {
      final user = this.localUserRepo!.findCachedUser();
      if (user?.id != null) {
        return this.remoteUserRepo!.resendActivationCode(userId: user!.id!);
      }
      // in case there is internet and status code != 200
      return Future.value(false);
    }
    return Future.value(false);
  }

  @override
  Future<Either<Failure, User>> setForgetPassword({required String code, required String password}) async {
    // TODO: implement setForgetPassword
    if (await networkInfo!.isConnected) {
      try {
        final remoteUser = await this.remoteUserRepo!.setForgetPassword(code: code, password: password);
        /*
        * don't cache user because set pasword will return all tokens
        * but the user will be redirect to login so no need to get tokens twice
        * and also if you cache all tokens, the user will exit the app and open it and enter to home page with no need to login
        * */
        return Right(remoteUser);
      } on HttpException catch (httpException) {
        return Left(HttpFailure(httpException.remoteMessageError));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // TODO: implement local user repo
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, User?>> getUser({DataSource dataSource = DataSource.REMOTE}) async {
    // TODO: implement getUser
    if (dataSource == DataSource.REMOTE) {
      if (await networkInfo!.isConnected) {
        try {
          final localUser = this.localUserRepo!.findCachedUser();
          if (localUser?.id != null && await isLogged()) {
            final remoteUser = await this.remoteUserRepo!.findById(userId: localUser!.id!, accessToken: localUser.access!);
            // NB IF YOU TRY TO USE OTHER USER_ID THAN CURRENT LOGGED USER PLEASE COMMENT LINE BELLOW
            await localUserRepo!.cache(remoteUser);
            return Right(remoteUser);
          } else {
            return Left(TokenFailure());
          }
        } on HttpException catch (httpException) {
          return Left(HttpFailure(httpException.remoteMessageError));
        } on ServerException {
          return Left(ServerFailure());
        } on TokenException {
          return Left(TokenFailure());
        }
      } else {
        // TODO: implement local user repo
        return Left(ConnectionFailure());
      }
    } else {
      //DataSource.LOCAL
      final localUser = this.localUserRepo!.findCachedUser();
      return Right(localUser);
    }
  }

  @override
  Future<bool> logout() async {
    // TODO: implement logout
    final localUser = this.localUserRepo!.findCachedUser();
    if (localUser?.access != null) {
      if (await this.localUserRepo!.clearCachedUser()) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  @override
  Future<Either<Failure, User>> updateUser({UserDto? userProfile}) async {
    // TODO: implement updateUser
    if (await networkInfo!.isConnected) {
      try {
        final localUser = this.localUserRepo!.findCachedUser();

        if (localUser?.access != null && localUser?.id != null && await isLogged()) {
          final remoteUser = await this.remoteUserRepo!.update(userId: localUser!.id!, userProfile: userProfile, accessToken: localUser.access!);
          await localUserRepo!.cache(remoteUser);
          return Right(remoteUser);
        } else {
          return Left(TokenFailure());
        }
      } on HttpException catch (httpException) {
        return Left(HttpFailure(httpException.remoteMessageError));
      } on ServerException {
        return Left(ServerFailure(message: Messages.SAVED_FAILURE));
      } on TokenException {
        return Left(TokenFailure());
      }
    } else {
      // TODO: implement local user repo
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<bool> hasNewFriend(bool value) {
    // TODO: implement hasNewFriend
    return this.localUserRepo!.hasNewFriend(value);
  }

  @override
  Future<bool> hasNewMessage(bool value) {
    // TODO: implement hasNewMessage
    return this.localUserRepo!.hasNewMessage(value);
  }

  @override
  Future<Either<Failure, User>> activate({required String code}) async {
    // TODO: implement activate
    if (await networkInfo!.isConnected) {
      try {
        final currentUser = await localUserRepo!.findCachedUser();
        //NULL SAFETY
        if (currentUser?.id == null || code == null) return Left(ServerFailure());

        final remoteUser = await this.remoteUserRepo!.activate(userId: currentUser!.id!, code: code);
        localUserRepo!.cache(remoteUser);
        return Right(remoteUser);
      } on HttpException catch (httpException) {
        return Left(HttpFailure(httpException.remoteMessageError));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // TODO: implement local user repo
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getPublicUser({required int userId}) async {
    // TODO: implement getPublicUser
    if (await networkInfo!.isConnected) {
      try {
        final localUser = this.localUserRepo!.findCachedUser();
        if (localUser?.id != null && await isLogged()) {
          final remoteUser = await this.remoteUserRepo!.findById(userId: userId, accessToken: localUser!.access!, isPublic: userId != localUser.id);
          return Right(remoteUser);
        } else {
          print('getPublicUser TokenFailure0 user_id=$userId');
          return Left(TokenFailure());
        }
      } on HttpException catch (httpException) {
        return Left(HttpFailure(httpException.remoteMessageError));
      } on ServerException {
        return Left(ServerFailure());
      } on TokenException {
        print('getPublicUser TokenFailure1 user_id=$userId');
        return Left(TokenFailure());
      }
    } else {
      // TODO: implement local user repo
      return Left(ConnectionFailure());
    }
  }
}
