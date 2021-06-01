import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_starter/config/messages.dart';
import 'package:flutter_starter/core/error/exceptions.dart';
import 'package:flutter_starter/data/datasources/remote/error/remote_message_error.dart';
import 'package:flutter_starter/data/models/dto/events_dto.dart';
import 'package:flutter_starter/data/models/event.dart';
import 'package:flutter_starter/data/models/favourite.dart';
import 'package:flutter_starter/data/models/pagination.dart';
import 'package:flutter_starter/data/utils/dateconverter.dart';

abstract class RemoteEventRepo {
  Future<Pagination<Event>> findAll({
    required String accessToken,
    EventsDto? eventsDto,
  });

  Future<Favourite> addFavouriteByEventId({
    required String accessToken,
    required int eventId,
  });

  Future<Event?> deleteFavouriteByEventId({
    required String accessToken,
    required int eventId,
    EventsDto? eventsDto,
  });

  Future<Event> findById({
    required int eventId,
    required String accessToken,
  });
}

@Injectable(as: RemoteEventRepo)
class RemoteEventRepoImpl implements RemoteEventRepo {
  Dio? dio;

  RemoteEventRepoImpl(this.dio) {
    /*dio.interceptors.add(InterceptorsWrapper(
        onRequest: (Options options) async {
          if (csrfToken == null) {
            print("no token，request token firstly...");
            //lock the dio.
            dio.lock();
            return tokenDio.get("/token").then((d) {
              options.headers["csrfToken"] = csrfToken = d.data['data']['token'];
              print("request token succeed, value: " + d.data['data']['token']);
              print(
                  'continue to perform request：path:${options.path}，baseURL:${options.path}');
              return options;
            }).whenComplete(() => dio.unlock()); // unlock the dio
          } else {
            options.headers["csrfToken"] = csrfToken;
            return options;
          }
        },
        onResponse: (e) {
    dio.unlock()
        },
    ));*/
  }

  @override
  Future<Pagination<Event>> findAll({required String accessToken, EventsDto? eventsDto}) async {
    // TODO: implement findAll
    try {
      late var params;
      if (eventsDto != null) {
        params = {
          'page': '${eventsDto.page}',
          'page_size': eventsDto.pageSize,
        };

        if (eventsDto.society != null && eventsDto.society != -1) params['society'] = '${eventsDto.society}';
        if (eventsDto.isFollowed) params['followed'] = '';
        if (eventsDto.isAttending) params['attending'] = '';
        if (eventsDto.isAsc) params['asc'] = '';
        if (eventsDto.isFavourite) params['favorites'] = '';
        if (eventsDto.eventType != null) params['event_type'] = '${eventsDto.eventType}';
        if (eventsDto.text != null && eventsDto.text!.isNotEmpty) params['text'] = eventsDto.text;
        /*//upcomin & old
        if (eventsDto.upcoming)
          params['upcoming'] = '';
        else if (eventsDto.old) params['old'] = '';*/

        if (eventsDto.sortBy != null) {
          if (eventsDto.sortBy == 'DISTANCE') {
            eventsDto.latitude = eventsDto.latitude ?? 0;
            eventsDto.latitude = eventsDto.longitude ?? 0;
            eventsDto.latitude = eventsDto.distance ?? 0;

            if (eventsDto.latitude != 0 && eventsDto.longitude != 0 && eventsDto.distance != 0) {
              params['latitude'] = eventsDto.latitude;
              params['longitude'] = eventsDto.longitude;
              params['distance'] = eventsDto.distance;
              params['sort_by'] = eventsDto.sortBy;
              params['asc'] = '';
            }
          } else {
            params['sort_by'] = eventsDto.sortBy;
          }
        }

        if (eventsDto.startDateLte != null) params['start_date__lte'] = DateConverter.toJson(date: eventsDto.startDateLte);
        if (eventsDto.startDateGte != null) params['start_date__gte'] = DateConverter.toJson(date: eventsDto.startDateGte);
        if (eventsDto.endDateLte != null) params['end_date__lte'] = DateConverter.toJson(date: eventsDto.endDateLte);
        if (eventsDto.endDateGte != null) params['end_date__gte'] = DateConverter.toJson(date: eventsDto.endDateGte);
      }
      final response = await dio!.get('/user/events/', queryParameters: params, options: Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'}));

      // to comment after
      /*if (eventsDto.isFollowed)
        Get.snackbar('[FETCH ATTENDED LIST API CALLED]', '[ENDPOINT=${response.request.uri}]', isDismissible: true, backgroundColor: DefaultTheme.success, duration: Duration(minutes: 1));
      */
      // as Map<String,dynamic> not json string as response.body of http package
      final responseData = response.data;

      if (response.statusCode == 200) {
        List<dynamic> dataList = responseData['events'];
        int? total = responseData['total'];

        final events = dataList.map((e) => Event.fromJson(e)).toList();
        final pagination = Pagination<Event>(list: events, total: total);
        return pagination;
      } else {
        throw DioError(response: response, requestOptions: response.requestOptions);
      }
    } on DioError catch (e) {
      //possible errors
      List<RemoteMessageError> rmerrors = [
        RemoteMessageError(code: 4, message: Messages.EVENTS_NOT_EXISTS),
      ];
      throw RemoteException(e: e, rmerrors: rmerrors);
    }
  }

  @override
  Future<Favourite> addFavouriteByEventId({required String accessToken, int? eventId}) async {
    // TODO: implement addFavouriteByEventId
    try {
      final response = await dio!.post('/user/favorite_events/',
          data: {
            'event': eventId,
          },
          options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'},
          ));

      // as Map<String,dynamic> not json string as response.body of http package
      final responseData = response.data;

      if (response.statusCode == 200) {
        final favourite = Favourite.fromJson(responseData);
        return favourite;
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
        if (responseData['code'] == 1) {
          message = Messages.EVENT_NOT_EXISTS;
        } else if (responseData['code'] == 16) {
          throw TokenException();
        } else if (responseData['code'] == 5) {
          message = Messages.EVENT_ALREADY_FAVOURITE;
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
  Future<Event?> deleteFavouriteByEventId({required String accessToken, int? eventId, EventsDto? eventsDto}) async {
    // TODO: implement deleteFavouriteByEventId
    try {
      late var params;
      if (eventsDto != null) {
        params = {
          'page': eventsDto.page.toString(),
          'page_size': eventsDto.pageSize.toString(),
        };
      }

      final response = await dio!.delete('/user/favorite_event/$eventId/',
          queryParameters: params,
          options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'},
          ));

      final responseData = response.data;

      if (response.statusCode == 200) {
        List<dynamic> dataList = responseData is List ? responseData : [];
        final events = dataList.map((e) => Event.fromJson(e)).toList();
        Event? event;
        if (events.isNotEmpty) event = events.last;
        return event;
      } else {
        throw DioError(response: response, requestOptions: response.requestOptions);
      }
    } on DioError catch (e) {
      final response = e.response;
      if (response?.data == null || response!.statusCode! >= 500) {
        throw ServerException();
      }
      //
      final responseData = response.data;
      if (responseData['code'] != null) {
        var message = responseData['message'];
        if (responseData['code'] == 16) {
          throw TokenException();
        } else if (responseData['code'] == 4) {
          message = Messages.EVENT_NOT_EXISTS;
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
  Future<Event> findById({required int eventId, required String accessToken}) async {
    // TODO: implement findById
    try {
      print('[track event findById] SENT');

      final response = await dio!.get('/user/event/$eventId/', options: Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'}));
      print('[track event findById] RECIVED ${response.statusCode}');

      // as Map<String,dynamic> not json string as response.body of http package
      final responseData = response.data;

      if (response.statusCode == 200) {
        final event = Event.fromJson(responseData);
        return event;
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
          throw TokenException();
        } else if (responseData['code'] == 4) {
          message = Messages.EVENT_NOT_EXISTS;
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
}
