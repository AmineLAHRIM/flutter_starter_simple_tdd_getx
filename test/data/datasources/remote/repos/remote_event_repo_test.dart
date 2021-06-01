import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:flutter_starter/config/messages.dart';
import 'package:flutter_starter/core/error/exceptions.dart';
import 'package:flutter_starter/data/datasources/remote/error/remote_message_error.dart';
import 'package:flutter_starter/data/datasources/remote/repos/remote_event_repo.dart';
import 'package:flutter_starter/data/models/dto/events_dto.dart';
import 'package:flutter_starter/data/models/event.dart';
import 'package:flutter_starter/data/models/favourite.dart';
import 'package:flutter_starter/data/models/pagination.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'remote_user_repo_test.mocks.dart';

/*class MockDio extends Mock implements Dio {
  @override
  BaseOptions options;

  MockDio({required this.options});
}*/

main() {
  // Here some classes declaration
  late RemoteEventRepo remoteEventRepo;
  late MockDio mockDio;
  final dioAdapter = DioAdapter();
  const int pageSize = 2;
  // MockOptions mockOptions;

  setUp(() {
    mockDio = MockDio();
    //mockDio.options=Constant.options;
    //mockDio.httpClientAdapter = dioAdapter;
    remoteEventRepo = RemoteEventRepoImpl(mockDio);
  });

  group('remote_event_repo', () {
    // Here some attribute to work with in the tests
    final eventsAll = json.decode(fixture('events_all.json'));
    final eventsAllFavorite = json.decode(fixture('events_all_favorite.json'));

    final addFavoriteRes200 = json.decode(fixture('add_favorite_res_200.json'));
    final favorite = Favourite.fromJson(addFavoriteRes200);

    final events = (eventsAll['events'] as List<dynamic>).map((e) => Event.fromJson(e)).toList();
    int? total = eventsAll['total'];

    group('findAll', () {
      final eventsDto = EventsDto(
        pageSize: pageSize,
        page: 1,
      );
      final accessToken =
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjEyNjgzMjYyLCJqdGkiOiI4NWRiMmNiNDEyZjA0MThjODJmNzMzNTcyY2E3NWU5MiIsInVzZXJfaWQiOjExfQ.J9lNODH77nCVdRcIxlVKMQspN0sKm1ve4156VpwZ1Ow';
      final REST_API = '/user/events/';

      Future<Pagination<Event>> fun() {
        return remoteEventRepo.findAll(
          eventsDto: eventsDto,
          accessToken: accessToken,
        );
      }

      test('should return [Pagination<Event>] when [POST request code is 200 (success)]', () async {
        // ARRANGE
        when(
          mockDio.get(
            REST_API,
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: eventsAll,
            statusCode: 200,
            requestOptions: RequestOptions(path: REST_API),
          ),
        );
        // ACT
        final result = await fun();
        // ASSERT
        verify(
          mockDio.get(
            REST_API,
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
          ),
        );

        final pagination = Pagination<Event>(list: events, total: total);
        expect(result, pagination);
      });

      test('should throw [ServerException] when [status code is > 500]', () async {
        // ARRANGE
        when(mockDio.get(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {},
              statusCode: 500,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.get(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw [ServerException] when [response?.data is null] ', () async {
        // ARRANGE
        when(mockDio.get(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.get(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw [TokenException] when [code=16 refreshToken is expired]', () async {
        // ARRANGE
        when(mockDio.get(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {"code": 16},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.get(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')));
        expect(call, throwsA(isA<TokenException>()));
      });

      test('should throw [HttpException] when [response have no implemented code and have a message]', () async {
        // ARRANGE
        when(mockDio.get(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {"code": 999, "message": "test message"},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.get(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')));
        expect(call, throwsA(isA<HttpException>()));
      });

      test('should throw [ServerException] when [response have no implemented code and no message]', () async {
        // ARRANGE
        when(mockDio.get(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {
                "code": 999,
              },
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.get(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw [ServerException] when [response have no code]', () async {
        // ARRANGE
        when(mockDio.get(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {
                "message": "test message",
              },
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.get(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')));
        expect(call, throwsA(isA<ServerException>()));
      });
    });

    group('addFavouriteByEventId', () {
      final eventsDto = EventsDto(
        pageSize: pageSize,
        page: 1,
      );
      final accessToken =
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjEyNjgzMjYyLCJqdGkiOiI4NWRiMmNiNDEyZjA0MThjODJmNzMzNTcyY2E3NWU5MiIsInVzZXJfaWQiOjExfQ.J9lNODH77nCVdRcIxlVKMQspN0sKm1ve4156VpwZ1Ow';
      final eventId = 19;
      final REST_API = '/user/favorite_events/';

      Future<Favourite> fun() {
        return remoteEventRepo.addFavouriteByEventId(
          accessToken: accessToken,
          eventId: eventId,
        );
      }

      test('should return [Favourite] when [POST request code is 200 (success)]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: addFavoriteRes200,
              statusCode: 200,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final result = await fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: anyNamed('data'), options: anyNamed('options')));

        expect(result, favorite);
      });

      test('should throw [ServerException] when [status code is > 500]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {},
              statusCode: 500,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: anyNamed('data'), options: anyNamed('options')));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw [ServerException] when [response?.data is null] ', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: anyNamed('data'), options: anyNamed('options')));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw [HttpException] => RemoteMessageError with [code=1 && message=Messages.EVENT_NOT_EXISTS] when [code=1 refreshToken is expired]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {"code": 1},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: anyNamed('data'), options: anyNamed('options')));
        HttpException httpException = HttpException(RemoteMessageError(code: 1, message: Messages.EVENT_NOT_EXISTS));
        expect(call, throwsA(httpException));
      });

      test('should throw [TokenException] when [code=16 refreshToken is expired]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {"code": 16},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: anyNamed('data'), options: anyNamed('options')));
        expect(call, throwsA(isA<TokenException>()));
      });

      test('should throw [HttpException] => RemoteMessageError with [code=5 && message=Messages.EVENT_ALREADY_FAVOURITE] when [code=1 refreshToken is expired]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {"code": 5},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: anyNamed('data'), options: anyNamed('options')));
        HttpException httpException = HttpException(RemoteMessageError(code: 5, message: Messages.EVENT_ALREADY_FAVOURITE));
        expect(call, throwsA(httpException));
      });

      test('should throw [HttpException] when [response have no implemented code and have a message]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {"code": 999, "message": "test message"},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: anyNamed('data'), options: anyNamed('options')));
        expect(call, throwsA(isA<HttpException>()));
      });

      test('should throw [ServerException] when [response have no implemented code and no message]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {
                "code": 999,
              },
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: anyNamed('data'), options: anyNamed('options')));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw [ServerException] when [response have no code]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {
                "message": "test message",
              },
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: anyNamed('data'), options: anyNamed('options')));
        expect(call, throwsA(isA<ServerException>()));
      });
    });

    group('deleteFavouriteByEventId', () {
      final eventsDto = EventsDto(
        pageSize: pageSize,
        page: 1,
      );
      final accessToken =
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjEyNjgzMjYyLCJqdGkiOiI4NWRiMmNiNDEyZjA0MThjODJmNzMzNTcyY2E3NWU5MiIsInVzZXJfaWQiOjExfQ.J9lNODH77nCVdRcIxlVKMQspN0sKm1ve4156VpwZ1Ow';
      final eventId = 19;
      final REST_API = '/user/favorite_event/$eventId/';

      Future<Event?> fun() {
        return remoteEventRepo.deleteFavouriteByEventId(
          accessToken: accessToken,
          eventId: 19,
          eventsDto: eventsDto,
        );
      }

      // return a pagination list from the whole list
      List<Event>? returnedPaginationList({
        List<Event>? list,
        EventsDto? eventsDto,
      }) {
        int v = 0;
        int currentPage = 1;
        List<Event> returnedList = [];
        int currentIndex = 0;
        if (eventsDto == null) {
          eventsDto = EventsDto(pageSize: pageSize, page: 1);
        }
        if (eventsDto.page == -1) return null;

        for (int index = 0; index <= list!.length - 1; index++) {
          if (v == 2) {
            v = 0;
            currentPage++;
          }
          v++;

          if (currentPage == eventsDto.page) {
            currentIndex = index;
            if (index >= currentIndex && index <= currentIndex + eventsDto.pageSize - 1) {
              returnedList.add(list[index]);
              if (returnedList.length == eventsDto.pageSize) {
                return returnedList;
              }
            }
          }
        }
      }

      // to return next list after unfavorie an event
      List<Event> returnedReplacedPaginationEventList({
        int? eventId,
        required List<Event> list,
        EventsDto? eventsDto,
      }) {
        if (eventsDto == null) {
          eventsDto = EventsDto(pageSize: pageSize, page: 1);
        }
        // Remove event before get new pagination list
        final eventIndex = list.indexWhere((element) => element.id == eventId);
        if (eventIndex != -1) list.removeAt(eventIndex);

        List<Event>? returnedlist = returnedPaginationList(list: list, eventsDto: eventsDto);
        return returnedlist ?? [];
      }

      // to return replaced unfavoire event [last event in current page with same pageSize]
      Event? returnedReplacedDeletedFavoriteEvent({
        int? eventId,
        required List<Event> list,
        EventsDto? eventsDto,
      }) {
        final returnedlist = returnedReplacedPaginationEventList(
          eventId: eventId,
          list: list,
          eventsDto: eventsDto,
        );

        if (returnedlist != null && returnedlist.isNotEmpty) {
          return returnedlist.last;
        }
        return null;
      }

      test('should return [Event] when [delete request code is 200 (success) and returned list is not empty]', () async {
        // ARRANGE

        final returnedList = returnedReplacedPaginationEventList(eventId: eventId, list: events, eventsDto: EventsDto(page: 1, pageSize: pageSize));
        final returnedListJson = returnedList.map((e) => e.toJson()).toList();

        when(mockDio.delete(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: returnedListJson,
              statusCode: 200,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final result = await fun();
        final event = returnedReplacedDeletedFavoriteEvent(list: events, eventId: eventId, eventsDto: EventsDto(page: 1, pageSize: pageSize));

        // ASSERT
        verify(mockDio.delete(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')));

        expect(result, event);
      });

      test('should throw [ServerException] when [status code is > 500]', () async {
        // ARRANGE
        when(mockDio.delete(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {},
              statusCode: 500,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.delete(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw [ServerException] when [response?.queryParameters is null] ', () async {
        // ARRANGE
        when(mockDio.delete(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.delete(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw [HttpException] => RemoteMessageError with [code=4 && message=Messages.EVENT_NOT_EXISTS] when [event not exist on favorite list anymore]', () async {
        // ARRANGE
        when(mockDio.delete(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {"code": 4},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.delete(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')));
        HttpException httpException = HttpException(RemoteMessageError(code: 4, message: Messages.EVENT_NOT_EXISTS));
        expect(call, throwsA(httpException));
      });

      test('should throw [TokenException] when [code=16 refreshToken is expired]', () async {
        // ARRANGE
        when(mockDio.delete(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {"code": 16},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.delete(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')));
        expect(call, throwsA(isA<TokenException>()));
      });

      test('should throw [HttpException] when [response have no implemented code and have a message]', () async {
        // ARRANGE
        when(mockDio.delete(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {"code": 999, "message": "test message"},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.delete(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')));
        expect(call, throwsA(isA<HttpException>()));
      });

      test('should throw [ServerException] when [response have no implemented code and no message]', () async {
        // ARRANGE
        when(mockDio.delete(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {
                "code": 999,
              },
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.delete(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw [ServerException] when [response have no code]', () async {
        // ARRANGE
        when(mockDio.delete(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {
                "message": "test message",
              },
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.delete(REST_API, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')));
        expect(call, throwsA(isA<ServerException>()));
      });
    });
  });
}
