import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter/core/network/network_info.dart';
import 'package:mockito/mockito.dart';

enum ConnectivityCase { CASE_ERROR, CASE_SUCCESS }

class MockConnectivity extends Mock implements Connectivity {
  var connectivityCase = ConnectivityCase.CASE_SUCCESS;

  Stream<ConnectivityResult>? _onConnectivityChanged;


  Future<ConnectivityResult> checkConnectivit() async {
    if (connectivityCase == ConnectivityCase.CASE_SUCCESS) {
      return Future.value(ConnectivityResult.wifi);
    } else {
      return Future.value(ConnectivityResult.none);

      //throw Error();
    }
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    if (_onConnectivityChanged == null) {
      _onConnectivityChanged =
          Stream<ConnectivityResult>.fromFutures([Future.value(ConnectivityResult.wifi), Future.value(ConnectivityResult.none), Future.value(ConnectivityResult.mobile)])
              .asyncMap((data) async {
        await Future.delayed(const Duration(seconds: 1));
        return data;
      });
    }
    return _onConnectivityChanged!;
  }

  @override
  Future<String> getWifiBSSID() {
    return Future.value("");
  }

  @override
  Future<String> getWifiIP() {
    return Future.value("");
  }

  @override
  Future<String> getWifiName() {
    return Future.value("");
  }
}

void main() {
  late NetworkInfoImpl networkInfoImpl;
  MockConnectivity? mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfoImpl = NetworkInfoImpl(connectivity: mockConnectivity);
  });

  group('isConnected', () {
    test('should return [true] when [checkConnectivity() is ConnectivityResult.wifi]', () async {
      // ARRANGE
      //var checkConnectivity = await mockConnectivity!.checkConnectivity();
      when(mockConnectivity!.checkConnectivit()).thenAnswer((realInvocation) {
        return Future.value(ConnectivityResult.wifi);
      });
      //when(mockConnectivity!.checkConnectivity()).thenAnswer(((_) => tHasConnectionFuture!) as Future<ConnectivityResult> Function(Invocation));
      // ACT
      final result = await networkInfoImpl.isConnected;
      // ASSERT
      verify(mockConnectivity!.checkConnectivity());
      //Future<bool> hasConnected=tHasConnectionFuture == ConnectivityResult.wifi || tHasConnectionFuture == ConnectivityResult.mobile;
      expect(result, true);
    });

    test('should return [true] when [checkConnectivity() is ConnectivityResult.mobile]', () async {
      // ARRANGE
      Future<ConnectivityResult> tHasConnectionFuture;
      var checkConnectivity = await mockConnectivity!.checkConnectivity();
      when(mockConnectivity!.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.mobile);
      //when(mockConnectivity!.checkConnectivity()).thenAnswer(((_) => tHasConnectionFuture!) as Future<ConnectivityResult> Function(Invocation));
      // ACT
      final result = await networkInfoImpl.isConnected;
      // ASSERT
      verify(mockConnectivity!.checkConnectivity());
      //Future<bool> hasConnected=tHasConnectionFuture == ConnectivityResult.wifi || tHasConnectionFuture == ConnectivityResult.mobile;
      expect(result, true);
    });

    test('should return [false] when [checkConnectivity() is ConnectivityResult.none]', () async {
      // ARRANGE
      Future<ConnectivityResult>? tHasConnectionFuture;
      when(mockConnectivity!.checkConnectivity()).thenAnswer((_) async => tHasConnectionFuture!);
      //when(mockConnectivity!.checkConnectivity()).thenAnswer(((_) => tHasConnectionFuture!) as Future<ConnectivityResult> Function(Invocation));
      // ACT
      final result = await networkInfoImpl.isConnected;
      // ASSERT
      verify(mockConnectivity!.checkConnectivity());
      //Future<bool> hasConnected=tHasConnectionFuture == ConnectivityResult.wifi || tHasConnectionFuture == ConnectivityResult.mobile;
      expect(result, false);
    });
  });
}
