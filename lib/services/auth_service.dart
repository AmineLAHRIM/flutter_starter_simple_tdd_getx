import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_starter/core/error/failures.dart';
import 'package:flutter_starter/core/routes/app_routes.dart';
import 'package:flutter_starter/data/models/dto/user_dto.dart';
import 'package:flutter_starter/data/models/enums/data_source.dart';
import 'package:flutter_starter/data/models/university.dart';
import 'package:flutter_starter/data/models/user.dart';
import 'package:flutter_starter/data/repos/abstract/user_repo.dart';

@lazySingleton
class AuthService {
  var currentUser = Rx<User?>(null);

  var email = ''.obs;

  List<Function>? funcsAfterNewtowkSuccess;

  // Repos
  UserRepo? userRepo;

  //EventService eventService;
  //OrderService orderService;

  bool isRedirectedToLogout = false;

  AuthService({this.userRepo}) {
    initCurrentUser();
  }

  Future<Either<Failure, User>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required University university,
  }) {
    return this.userRepo!.signUp(firstName: firstName, lastName: lastName, email: email, password: password, university: university);
  }

  Future<Either<Failure, User>> logIn({
    required String email,
    required String password,
  }) {
    return this.userRepo!.logIn(email: email, password: password);
  }

  Future<Either<Failure, User>> activate({required String code}) async {
    final isRegsitred = await this.userRepo!.isRegistred();
    if (isRegsitred) {
      return this.userRepo!.activate(code: code);
    } else {
      return Left(RouteFailure());
    }
  }

  Future<bool> isRegistred() {
    return this.userRepo!.isRegistred();
  }

  Future<bool> isLogged() {
    return this.userRepo!.isLogged();
  }

  Future<Either<Failure, User?>> getUser({DataSource dataSource = DataSource.REMOTE}) {
    return this.userRepo!.getUser(dataSource: dataSource);
  }

  Future<Either<Failure, bool>> resetPassword({required String email}) async {
    final failureOrIsResetted = await this.userRepo!.resetPassword(email: email);
    if (failureOrIsResetted.isRight()) {
      this.email.value = email;
    }

    return failureOrIsResetted;
  }

  Future<bool> resendActivationCode() async {
    return this.userRepo!.resendActivationCode();
  }

  Future<Either<Failure, User>> setForgetPassword({required String code, required String password}) {
    return this.userRepo!.setForgetPassword(code: code, password: password);
  }

  Future<bool> logout({byToken = false}) async {
    if (!isRedirectedToLogout) {
      isRedirectedToLogout = true;

      final isLoggedOut = await this.userRepo!.logout();
      if (isLoggedOut) {
        print('routing previous ${Get.routing.previous}');
        dispose();
        FirebaseMessaging.instance.deleteToken();
        //eventService.dispose();
        //orderService.dispose();

        //await Future.delayed(Duration(seconds: 1));
        if (byToken) {
          Get.offAllNamed(AppRoutes.LOGIN, arguments: RouteFailure());
        } else {
          Get.offAllNamed(AppRoutes.LOGIN);
        }
        return true;
      }
    }
    return false;
  }

  @disposeMethod
  void dispose() {
    this.currentUser.value = null;
    this.email.value = '';
    // reset EventService
  }

  Future<Either<Failure, User>> updateUser(UserDto userProfile) {
    return this.userRepo!.updateUser(userProfile: userProfile);
  }

  Future<bool> switchNewFriend(bool value) {
    return this.userRepo!.hasNewFriend(value);
  }

  Future<bool> switchNewMessage(bool value) {
    return this.userRepo!.hasNewMessage(value);
  }

  void initCurrentUser() async {
    final failureOrUser = await getUser(dataSource: DataSource.LOCAL);
    failureOrUser.fold((failure) {
      currentUser.value = null;
    }, (user) {
      currentUser.value = user;
    });
  }
}
