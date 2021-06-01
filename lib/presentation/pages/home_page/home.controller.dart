import 'package:flutter_starter/core/error/errors.dart';
import 'package:flutter_starter/core/error/failures.dart';
import 'package:flutter_starter/core/loading/loading_state.dart';
import 'package:flutter_starter/services/auth_service.dart';
import 'package:flutter_starter/services/event_service.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeController extends GetxController{

  //States
  // we user LoadingState instead of Enum because Error need to have message and type
  // LoadingState have EMPTY,ERROR(with two params {String? message, MessageType? type}),LOADING,LOADED
  var userProfileState = Rx<LoadingState?>(null);


  //Services
  EventService? eventService;
  // we can user this service when there is failure of Access Token
  AuthService? authService;


  HomeController({this.eventService,this.authService});

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    setupProfile();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void setupProfile() async {
    // HERE how to user it with REST API
    /*userProfileState.value = LOADING();
    final failureOrUser = await authService!.getUser();
    failureOrUser.fold((failure) {
      if (failure is TokenFailure) {
        authService!.logout(byToken: true);
      } else {
        userProfileState.value = ERROR(message: failure.toString(), type: MessageType.danger);
      }
    }, (user) {
      this.authService!.currentUser.value = user;
      userProfileState.value = LOADED();
    });*/

    // HERE a Simulation of REST API
    userProfileState.value = LOADING();

    await Future.delayed(Duration(seconds: 2));
    userProfileState.value = LOADED();

    await Future.delayed(Duration(seconds: 2));
    userProfileState.value = ERROR(message: 'Error Message Here',type: MessageType.danger);

    await Future.delayed(Duration(seconds: 2));
    userProfileState.value = EMPTY();

  }
}