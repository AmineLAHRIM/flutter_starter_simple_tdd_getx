
import 'package:dio/dio.dart';
import 'package:flutter_starter/core/network/network_info.dart';

class DioConnectivityRequestRetrier {
  final Dio dio;
  final NetworkInfo networkInfo;

  DioConnectivityRequestRetrier({
    required this.dio,
    required this.networkInfo,
  });

/*Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    late StreamSubscription streamSubscription;
    final responseCompleter = Completer<Response>();

    streamSubscription = networkInfo.dataConnectionChecker!.onStatusChange.listen(
      (dataConnectionStatus) {
        if (dataConnectionStatus != DataConnectionStatus.connected) {
          streamSubscription.cancel();
          responseCompleter.complete(
            dio.request(
              requestOptions.path,
              cancelToken: requestOptions.cancelToken,
              data: requestOptions.data,
              onReceiveProgress: requestOptions.onReceiveProgress,
              onSendProgress: requestOptions.onSendProgress,
              queryParameters: requestOptions.queryParameters,
              //options: requestOptions,
            ),
          );
        }
      },
    );

    return responseCompleter.future;
  }*/
}
