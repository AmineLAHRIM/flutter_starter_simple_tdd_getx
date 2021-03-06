import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:injectable/injectable.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;

  late StreamController<ConnectivityResult> connectionRestoredStream;

  //DataConnectionChecker? dataConnectionChecker;

  Connectivity? connectivity;
}

@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  //DataConnectionChecker? dataConnectionChecker;
  Connectivity? connectivity;
  late StreamController<ConnectivityResult> connectionRestoredStream;
  ConnectivityResult? _oldConnectivityResultStatus;

  NetworkInfoImpl({this.connectivity}) {
    setupConnectivityLister();
  }

  /*@override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;*/

  @override
  Future<bool> get isConnected async {
    ConnectivityResult connectivityResult = await connectivity!.checkConnectivity();
    if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return false;
  }

  void setupConnectivityLister() {
    connectionRestoredStream = StreamController<ConnectivityResult>();
    connectivity!.onConnectivityChanged.listen((connectivityResult) async {
      print('connectivity changed from $_oldConnectivityResultStatus => $connectivityResult');
      if (connectivityResult == ConnectivityResult.wifi) {
        if (_oldConnectivityResultStatus == null || _oldConnectivityResultStatus == ConnectivityResult.none) {
          connectionRestoredStream.sink.add(connectivityResult);
        }
        _oldConnectivityResultStatus = ConnectivityResult.wifi;
      } else if (connectivityResult == ConnectivityResult.mobile) {
        if (_oldConnectivityResultStatus == null || _oldConnectivityResultStatus == ConnectivityResult.none) {
          connectionRestoredStream.sink.add(connectivityResult);
        }
        _oldConnectivityResultStatus = ConnectivityResult.mobile;
      } else if (connectivityResult == ConnectivityResult.none) {
        _oldConnectivityResultStatus = ConnectivityResult.none;
      }
    });
  }
}
