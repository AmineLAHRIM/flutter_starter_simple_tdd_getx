import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:flutter_starter/data/datasources/local/shared_prefs_constant.dart';
import 'package:flutter_starter/data/models/university.dart';
import 'package:flutter_starter/data/models/user.dart';
import 'package:flutter_starter/data/utils/dateconverter.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalUserRepo {
  /// cache [User] which was gotten the last time
  /// the user had an internet connection.
  ///
  Future<bool> cache(User user);

  /// SignUp [User attributes] which was gotten the last time
  /// the user had an internet connection.
  ///
  Future<User> signUp({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    University? university,
  });

  /*
  *  get cached user
  * */
  User? findCachedUser();

  Future<bool> clearCachedUser();

  Future<bool> hasNewFriend(bool value);

  Future<bool> hasNewMessage(bool value);
}

@Injectable(as: LocalUserRepo)
class LocalUserRepoImpl implements LocalUserRepo {
  SharedPreferences? prefs;

  LocalUserRepoImpl({this.prefs});

  @override
  Future<bool> cache(User user) async {
    // TODO: implement cache
    /*
    * this for response that have not access or refrech token so cache them
    * without nullable to token filed in the cache
    * */
    if (user.access == null || user.refresh == null) {
      final localUser = findCachedUser();
      if (localUser?.access != null) {
        user.access = localUser!.access;
        user.accessExpiryAt = localUser.accessExpiryAt;
        user.refresh = localUser.refresh;
        user.refreshExpiryAt = localUser.refreshExpiryAt;
      }
    }
    //because it's converted in the rest api to device local timezone before it cached so it's not Utc
    final jsonString = user.toJson(isUtc: false,dateFormatSource: DateFormatSource.ISO);
    return prefs!.setString(
      USER,
      json.encode(jsonString),
    );
  }

  @override
  Future<User> signUp({String? firstName, String? lastName, String? email, String? password, University? university}) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  User? findCachedUser() {
    // TODO: implement findById
    final jsonString = prefs!.getString(USER);
    if (jsonString != null) {
      dynamic data = json.decode(jsonString);
      User userLocal=User.fromJson(data, isUtc: true,dateFormatSource: DateFormatSource.ISO);
      return userLocal;
    } else {
      return null;
    }
  }

  @override
  Future<bool> clearCachedUser() {
    // TODO: implement clearCachedUser
    return prefs!.remove(USER);
  }

  @override
  Future<bool> hasNewFriend(bool value) {
    // TODO: implement hasNewFriend
    return prefs!.setBool(
      NOTF_IS_NEW_FRIEND,
      value,
    );
  }

  @override
  Future<bool> hasNewMessage(bool value) {
    // TODO: implement hasNewMessage
    return prefs!.setBool(
      NOTF_IS_NEW_MESSAGE,
      value,
    );
  }
}
