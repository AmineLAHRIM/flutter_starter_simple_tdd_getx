import 'package:equatable/equatable.dart';
import 'package:flutter_starter/config/messages.dart';
import 'package:flutter_starter/data/datasources/remote/error/remote_message_error.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {
  String? message;

  ServerFailure({this.message});

  @override
  String toString() {
    return message ?? Messages.SERVER_FAILURE;
  }
}

class CacheFailure extends Failure {
  String? message;

  CacheFailure({this.message});

  @override
  String toString() {
    return message ?? 'Cache failure!';
  }
}

class RouteFailure extends Failure {
  String? message;

  RouteFailure({this.message});

  @override
  String toString() {
    return message ?? 'For Security Reasons please try again!';
  }
}

class DataSourceFailure extends Failure {
  String? message;

  DataSourceFailure({this.message});

  @override
  String toString() {
    return message ?? 'Please try again later!';
  }
}

class ConnectionFailure extends Failure {
  String? message;

  ConnectionFailure({this.message});

  @override
  String toString() {
    return message ?? Messages.NO_CONNECTION;
  }
}

class HttpFailure extends Failure {
  final RemoteMessageError remoteMessageError;

  HttpFailure(this.remoteMessageError);

  @override
  String toString() {
    return remoteMessageError.message!;
  }
}

class TokenFailure extends Failure {
  String? message;

  TokenFailure({this.message});

  @override
  String toString() {
    return message ?? 'For security Reasion please try again!';
  }
}

class StripeCheckoutFailure extends Failure {
  final String message;

  StripeCheckoutFailure(this.message);

  @override
  String toString() {
    return message;
  }
}
