import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter/config/messages.dart';
import 'package:flutter_starter/core/error/exceptions.dart';
import 'package:flutter_starter/data/datasources/remote/error/remote_message_error.dart';
import 'package:flutter_starter/data/datasources/remote/repos/remote_user_repo.dart';
import 'package:flutter_starter/data/models/dto/user_dto.dart';
import 'package:flutter_starter/data/models/token.dart';
import 'package:flutter_starter/data/models/university.dart';
import 'package:flutter_starter/data/models/user.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'remote_user_repo_test.mocks.dart';

/*class MockDio extends Mock implements Dio {
  @override
  BaseOptions options;

  MockDio({required this.options});
}*/

@GenerateMocks([Dio])
main() {
  // Here some classes declaration
  late RemoteUserRepoImpl userRepoImpl;
  late MockDio mockDio;

  // MockOptions mockOptions;

  setUp(() {
    mockDio = MockDio();
    //mockDio.options=Constant.options;
    //mockDio = MockDio(options: Constant.options);
    //mockDio.httpClientAdapter = dioAdapter;
    userRepoImpl = RemoteUserRepoImpl(mockDio);
  });

  group('remote_user_repo', () {
    // Here some attribute to work with in the tests

    group('signUp', () {
      final userSignUp = json.decode(fixture('user_sign_up.json'));
      final userSignUpRes = json.decode(fixture('user_sign_up_res.json'));
      final REST_API = '/user/signup/';
      Future<User> fun() {
        return userRepoImpl.signUp(
          firstName: userSignUp['first_name'],
          lastName: userSignUp['last_name'],
          email: userSignUp['email'],
          password: userSignUp['password'],
          university: University(id: userSignUp['university']),
        );
      }

      test('should return [user] when [POST request code is 200 (success)]', () async {
        // ARRANGE
        when(mockDio.post(
          REST_API,
          data: userSignUp,
        )).thenAnswer((_) async {
          return Response(
            data: userSignUpRes,
            statusCode: 200,
            requestOptions: RequestOptions(path: REST_API),
          );
        });

        // ACT
        final result = await userRepoImpl.signUp(
          firstName: userSignUp['first_name'],
          lastName: userSignUp['last_name'],
          email: userSignUp['email'],
          password: userSignUp['password'],
          university: University(id: 1),
        );
        // ASSERT
        verify(mockDio.post(REST_API, data: userSignUp));
        expect(result, isA<User>());
      });

      test('should throw [HttpException] when [POST request code is 404 or other (failure) && result a RemoteMessageError]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: userSignUp)).thenAnswer((_) async => Response(
              data: RemoteMessageError(message: 'not found', code: 1).toJson(),
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = userRepoImpl.signUp(
          firstName: userSignUp['first_name'],
          lastName: userSignUp['last_name'],
          email: userSignUp['email'],
          password: userSignUp['password'],
          university: University(id: userSignUp['university']),
        );
        // ASSERT
        verify(mockDio.post('/user/signup/', data: userSignUp));
        expect(call, throwsA(isA<HttpException>()));
      });

      test('should throw [ServerException] when [POST request code is 404 or other (failure) && result is other json]', () {
        // ARRANGE
        when(mockDio.post(REST_API, data: userSignUp)).thenAnswer((_) async => Response(
              data: {},
              statusCode: 404,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.post('/user/signup/', data: userSignUp));
        expect(call, throwsA(isA<ServerException>()));
      });
      test('should throw [ServerException] when [response have no implemented code and no message]', () {
        // ARRANGE
        when(mockDio.post(REST_API, data: userSignUp)).thenAnswer((_) async => Response(
              data: {"code": 999},
              statusCode: 404,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.post('/user/signup/', data: userSignUp));
        expect(call, throwsA(isA<ServerException>()));
      });
      test('should throw [HttpException] when [response have no implemented code and have a message]', () {
        // ARRANGE
        when(mockDio.post(REST_API, data: userSignUp)).thenAnswer((_) async => Response(
              data: {"code": 999, "message": "test message"},
              statusCode: 404,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.post('/user/signup/', data: userSignUp));
        expect(call, throwsA(isA<HttpException>()));
      });
    });

    group('activate', () {
      final activate = json.decode(fixture('activate.json'));
      final activateRes200 = json.decode(fixture('activate_res_200.json'));
      final userId = 40;
      final REST_API = '/user/activate/$userId/';

      test('should return [user] when [PUT request code is 200 (success)]', () async {
        // ARRANGE
        when(mockDio.put(REST_API, data: activate)).thenAnswer((_) async => Response(
              data: activateRes200,
              statusCode: 200,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final result = await userRepoImpl.activate(
          userId: userId,
          code: activate['code'],
        );
        // ASSERT
        verify(mockDio.put(REST_API, data: activate));
        expect(result, isA<User>());
      });

      test(
          'should throw  [HttpException] => [RemoteMessageError] with [code=1 & message=Messages.INVALID_CODE] when [user already activated] Or [invalid code] PUT request code is 400',
          () async {
        // ARRANGE
        when(mockDio.put(REST_API, data: activate)).thenAnswer((_) async => Response(
              data: {"message": "code", "code": 1},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = userRepoImpl.activate(
          userId: userId,
          code: activate['code'],
        );
        // ASSERT
        verify(mockDio.put(REST_API, data: activate));
        final httpException = HttpException(RemoteMessageError(code: 1, message: Messages.INVALID_CODE));
        //expect(call, throwsA(isA<HttpException>()));
        expect(call, throwsA(httpException));
      });

      test('should throw  [ServerException] when [response have no code]', () async {
        // ARRANGE
        when(mockDio.put(REST_API, data: activate)).thenAnswer((_) async => Response(
              data: {},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = userRepoImpl.activate(
          userId: userId,
          code: activate['code'],
        );
        // ASSERT
        verify(mockDio.put(REST_API, data: activate));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw  [ServerException] when [response have no implemented code and no message]', () async {
        // ARRANGE
        when(mockDio.put(REST_API, data: activate)).thenAnswer((_) async => Response(
              data: {"code": 999},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = userRepoImpl.activate(
          userId: userId,
          code: activate['code'],
        );
        // ASSERT
        verify(mockDio.put(REST_API, data: activate));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw  [HttpException] when [response have no implemented code and no message]', () async {
        // ARRANGE
        when(mockDio.put(REST_API, data: activate)).thenAnswer((_) async => Response(
              data: {
                "code": 999,
                "message": "test message",
              },
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = userRepoImpl.activate(
          userId: userId,
          code: activate['code'],
        );
        // ASSERT
        verify(mockDio.put(REST_API, data: activate));
        expect(call, throwsA(isA<HttpException>()));
      });
    });

    group('logIn', () {
      final signin = json.decode(fixture('signin.json'));
      final signinRes200 = json.decode(fixture('signin_res_200.json'));
      final userId = 10;
      final REST_API = '/user/signin/';

      test('should return [user] when [POST request code is 200 (success)]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: signin)).thenAnswer((_) async => Response(
              data: signinRes200,
              statusCode: 200,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final result = await userRepoImpl.logIn(
          email: signin['email'],
          password: signin['password'],
        );
        // ASSERT
        verify(mockDio.post(REST_API, data: signin));
        expect(result, User.fromJson(signinRes200));
      });

      test('should throw  [HttpException] => [RemoteMessageError] with [code=1 & message=Messages.INVALID_EMAIL_OR_PASSWORD] when [user enter invalid email or password]',
          () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: signin)).thenAnswer((_) async => Response(
              data: {"message": "code", "code": 1},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = userRepoImpl.logIn(
          email: signin['email'],
          password: signin['password'],
        );
        // ASSERT
        verify(mockDio.post(REST_API, data: signin));
        final httpException = HttpException(RemoteMessageError(code: 1, message: Messages.INVALID_EMAIL_OR_PASSWORD));
        //expect(call, throwsA(isA<HttpException>()));
        expect(call, throwsA(httpException));
      });

      test('should throw  [ServerException] when [response have no code]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: signin)).thenAnswer((_) async => Response(
              data: {},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = userRepoImpl.logIn(
          email: signin['email'],
          password: signin['password'],
        );
        // ASSERT
        verify(mockDio.post(REST_API, data: signin));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw  [ServerException] when [response have no implemented code and no message]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: signin)).thenAnswer((_) async => Response(
              data: {"code": 999},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = userRepoImpl.logIn(
          email: signin['email'],
          password: signin['password'],
        );
        // ASSERT
        verify(mockDio.post(REST_API, data: signin));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw  [HttpException] when [response have no implemented code and have a message]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: signin)).thenAnswer((_) async => Response(
              data: {
                "code": 999,
                "message": "test message",
              },
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = userRepoImpl.logIn(
          email: signin['email'],
          password: signin['password'],
        );
        // ASSERT
        verify(mockDio.post(REST_API, data: signin));
        expect(call, throwsA(isA<HttpException>()));
      });
    });

    group('refreshToken', () {
      final refresh =
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYxMjg5OTI2MiwianRpIjoiM2YxMTBmZDliMmFiNGU1N2JmNDg4ZmNmOTYxYmE3ZDIiLCJ1c2VyX2lkIjoxMX0.REa45V-sbKF5mIojs7dWlmktLxaLWuGuRer0Z26pPtk';
      final refreshTokenRes200 = json.decode(fixture('refresh_token_res_200.json'));
      final token = Token.fromJson(refreshTokenRes200);
      final REST_API = '/user/refresh_token/';

      test('should return [Token] when [POST request code is 200 (success)]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: {
          "refresh": refresh,
        })).thenAnswer((_) async => Response(
              data: refreshTokenRes200,
              statusCode: 200,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final result = await userRepoImpl.refreshToken(
          refresh: refresh,
        );
        // ASSERT
        verify(mockDio.post(REST_API, data: {
          "refresh": refresh,
        }));
        expect(result, token);
      });

      test('should throw  [HttpException] => [RemoteMessageError] with [code=16] when [refresh token is invalid or expired]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: {
          "refresh": refresh,
        })).thenAnswer((_) async => Response(
              data: {
                "code": 16,
              },
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = userRepoImpl.refreshToken(
          refresh: refresh,
        );
        // ASSERT
        verify(mockDio.post(REST_API, data: {
          "refresh": refresh,
        }));
        final httpException = HttpException(RemoteMessageError(code: 16, message: Messages.INVALID_TOKEN_OR_EXPIRED));
        expect(call, throwsA(httpException));
      });

      test('should throw  [ServerException] => [response have no code]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: {
          "refresh": refresh,
        })).thenAnswer((_) async => Response(
              data: {},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = userRepoImpl.refreshToken(
          refresh: refresh,
        );
        // ASSERT
        verify(mockDio.post(REST_API, data: {
          "refresh": refresh,
        }));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw  [ServerException] => [response have no implemented code and no message]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: {
          "refresh": refresh,
        })).thenAnswer((_) async => Response(
              data: {
                "code": 999,
              },
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = userRepoImpl.refreshToken(
          refresh: refresh,
        );
        // ASSERT
        verify(mockDio.post(REST_API, data: {
          "refresh": refresh,
        }));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw  [HttpException] => [response have no implemented code and have a message]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: {
          "refresh": refresh,
        })).thenAnswer((_) async => Response(
              data: {"code": 999, "message": "test message"},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = userRepoImpl.refreshToken(
          refresh: refresh,
        );
        // ASSERT
        verify(mockDio.post(REST_API, data: {
          "refresh": refresh,
        }));
        expect(call, throwsA(isA<HttpException>()));
      });
    });

    group('resetPassword', () {
      final email = '****************@gmail.com';
      final REST_API = '/user/reset_password/';

      Future<bool> fun() {
        return userRepoImpl.resetPassword(
          email: email,
        );
      }

      test('should return [true] when [POST request code is 200 (success)]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: {
          "email": email,
        })).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final result = await fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: {
          "email": email,
        }));
        expect(result, true);
      });

      test('should throw  [HttpException] => [RemoteMessageError] with [code=1 && message=Messages.HAS_NO_LINKED_ACCOUNT] when [email has no linked account]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: {
          "email": email,
        })).thenAnswer((_) async => Response(
              data: {
                "code": 1,
              },
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: {
          "email": email,
        }));
        final httpException = HttpException(RemoteMessageError(code: 1, message: Messages.HAS_NO_LINKED_ACCOUNT));
        expect(call, throwsA(httpException));
      });

      test('should throw  [ServerException] => [response have no code]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: {
          "email": email,
        })).thenAnswer((_) async => Response(
              data: {},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: {
          "email": email,
        }));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw  [ServerException] => [response have no implemented code and no message]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: {
          "email": email,
        })).thenAnswer((_) async => Response(
              data: {
                "code": 999,
              },
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: {
          "email": email,
        }));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw  [HttpExecption] => [response have no implemented code and have a message]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: {
          "email": email,
        })).thenAnswer((_) async => Response(
              data: {"code": 999, "message": "test message"},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: {
          "email": email,
        }));
        expect(call, throwsA(isA<HttpException>()));
      });
    });

    group('resendActivationCode', () {
      final userId = 10;
      final REST_API = '/user/activation_code/';

      Future<bool> fun() {
        return userRepoImpl.resendActivationCode(
          userId: userId,
        );
      }

      test('should return [true] when [POST request code is 200 (success)]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: {
          "id": userId,
        })).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final result = await fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: {
          "id": userId,
        }));
        expect(result, true);
      });

      test('should return  [false] when [POST request code is not 200 (failure)]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: {
          "id": userId,
        })).thenAnswer((_) async => Response(
              data: {},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final result = await fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: {
          "id": userId,
        }));
        expect(result, false);
      });
    });

    group('setForgetPassword', () {
      final code = 'P1YG6E';
      final password = 'testA@123';
      final REST_API = '/user/set_password/';
      final setPasswordRes200 = json.decode(fixture('set_password_res_200.json'));
      final user = User.fromJson(setPasswordRes200);

      Future<User>? fun() {
        return userRepoImpl.setForgetPassword(
          code: code,
          password: password,
        );
      }

      test('should return [User] when [POST request code is 200 (success)]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: {
          "code": code,
          "password": password,
          "confirm_password": password,
        })).thenAnswer((_) async => Response(
              data: setPasswordRes200,
              statusCode: 200,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final result = await fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: {
          "code": code,
          "password": password,
          "confirm_password": password,
        }));
        expect(result, user);
      });

      test('should throw  [HttpException] => RemoteMessageError with [code=1 && message=Messages.INVALID_CODE] when [code is invalid]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: {
          "code": code,
          "password": password,
          "confirm_password": password,
        })).thenAnswer((_) async => Response(
              data: {"code": 1},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: {
          "code": code,
          "password": password,
          "confirm_password": password,
        }));
        HttpException httpException = HttpException(RemoteMessageError(code: 1, message: Messages.INVALID_CODE));
        expect(call, throwsA(httpException));
      });

      test('should throw  [ServerException] when [response have no code]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: {
          "code": code,
          "password": password,
          "confirm_password": password,
        })).thenAnswer((_) async => Response(
              data: {},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: {
          "code": code,
          "password": password,
          "confirm_password": password,
        }));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw  [ServerException] when [response have no implemented code and no message]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: {
          "code": code,
          "password": password,
          "confirm_password": password,
        })).thenAnswer((_) async => Response(
              data: {"code": 999},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: {
          "code": code,
          "password": password,
          "confirm_password": password,
        }));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw  [HttpException] when [response have no implemented code and have a message]', () async {
        // ARRANGE
        when(mockDio.post(REST_API, data: {
          "code": code,
          "password": password,
          "confirm_password": password,
        })).thenAnswer((_) async => Response(
              data: {"code": 999, "message": "test message"},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.post(REST_API, data: {
          "code": code,
          "password": password,
          "confirm_password": password,
        }));
        expect(call, throwsA(isA<HttpException>()));
      });
    });

    group('findById', () {
      final userId = 10;
      final accessToken =
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjEyNjgzMjYyLCJqdGkiOiI4NWRiMmNiNDEyZjA0MThjODJmNzMzNTcyY2E3NWU5MiIsInVzZXJfaWQiOjExfQ.J9lNODH77nCVdRcIxlVKMQspN0sKm1ve4156VpwZ1Ow';
      final REST_API = '/user/profile/$userId/';
      final findByIdRes200 = json.decode(fixture('find_by_id_res_200.json'));
      final user = User.fromJson(findByIdRes200);
      final headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

      Future<User> fun() {
        return userRepoImpl.findById(
          userId: userId,
          accessToken: accessToken,
        );
      }

      test('should return [User] when [POST request code is 200 (success)]', () async {
        // ARRANGE
        when(mockDio.get(REST_API, options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: findByIdRes200,
              statusCode: 200,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final result = await fun();
        // ASSERT
        verify(mockDio.get(REST_API, options: anyNamed('options')));

        expect(result, user);
      });

      test('should throw  [ServerException] when [response has no code]', () async {
        // ARRANGE
        when(mockDio.get(REST_API, options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.get(REST_API, options: anyNamed('options')));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw  [TokenExecption] => RemoteMessageError with [code 16] when [refreshToken is expired]', () async {
        // ARRANGE
        when(mockDio.get(REST_API, options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {"code": 16},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.get(REST_API, options: anyNamed('options')));
        expect(call, throwsA(isA<TokenException>()));
      });

      test('should throw  [HttpException] => RemoteMessageError with [response has no implemented code and have a message] when [try to get a profile is not for you]', () async {
        // ARRANGE
        when(mockDio.get(REST_API, options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {"code": 999, "message": "test message"},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.get(REST_API, options: anyNamed('options')));
        expect(call, throwsA(isA<HttpException>()));
      });

      test('should throw  [ServerException] when [response has no implemented code and no message]', () async {
        // ARRANGE
        when(mockDio.get(REST_API, options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {
                "code": 999,
              },
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));

        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.get(REST_API, options: anyNamed('options')));
        expect(call, throwsA(isA<ServerException>()));
      });
    });

    group('update', () {
      final userId = 10;
      final updateProfileRes200 = json.decode(fixture('update_profile_res_200.json'));
      final user = User.fromJson(updateProfileRes200);
      final userProfile = UserDto(
          firstName: "Amine",
          lastName: "****************",
          email: "****************@gmail.com",
          degree: "IT Licence",
          university: University(id: 1),
          currentPassword: null,
          newPassword: null,
          confirmPassword: null,
          profilePicture: null);
      final accessToken =
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjEyNjgzMjYyLCJqdGkiOiI4NWRiMmNiNDEyZjA0MThjODJmNzMzNTcyY2E3NWU5MiIsInVzZXJfaWQiOjExfQ.J9lNODH77nCVdRcIxlVKMQspN0sKm1ve4156VpwZ1Ow';
      final REST_API = '/user/profile/$userId/';
      final headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

      Future<User> fun() {
        return userRepoImpl.update(
          userId: userId,
          userProfile: userProfile,
          accessToken: accessToken,
        );
      }

      test('should return [User] when [POST request code is 200 (success)]', () async {
        // ARRANGE
        when(mockDio.put(REST_API, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: updateProfileRes200,
              statusCode: 200,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final result = await fun();
        // ASSERT
        verify(mockDio.put(REST_API, data: anyNamed('data'), options: anyNamed('options')));

        expect(result, user);
      });

      test('should throw [HttpException] => RemoteMessageError with [ code=1 &&  message=Messages.INVALID_OLD_PASSWORD] when [try invalid old password]', () async {
        // ARRANGE
        when(mockDio.put(REST_API, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {"code": 1, "message": Messages.INVALID_OLD_PASSWORD},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.put(REST_API, data: anyNamed('data'), options: anyNamed('options')));
        HttpException httpException = HttpException(RemoteMessageError(code: 1, message: Messages.INVALID_OLD_PASSWORD));
        expect(call, throwsA(httpException));
      });

      test('should throw [TokenException] when [code=16 refreshToken is expired]', () async {
        // ARRANGE
        when(mockDio.put(REST_API, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {"code": 16},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.put(REST_API, data: anyNamed('data'), options: anyNamed('options')));
        expect(call, throwsA(isA<TokenException>()));
      });

      test('should throw [ServerException] when [response have no code]', () async {
        // ARRANGE
        when(mockDio.put(REST_API, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.put(REST_API, data: anyNamed('data'), options: anyNamed('options')));
        expect(call, throwsA(isA<ServerException>()));
      });

      test('should throw [HttpException] when [response have no implemented code and have a message]', () async {
        // ARRANGE
        when(mockDio.put(REST_API, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {"code": 999, "message": "test message"},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.put(REST_API, data: anyNamed('data'), options: anyNamed('options')));
        expect(call, throwsA(isA<HttpException>()));
      });

      test('should throw [ServerException] when [response have no implemented code and no message]', () async {
        // ARRANGE
        when(mockDio.put(REST_API, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {"code": 999},
              statusCode: 400,
              requestOptions: RequestOptions(path: REST_API),
            ));
        // ACT
        final call = fun();
        // ASSERT
        verify(mockDio.put(REST_API, data: anyNamed('data'), options: anyNamed('options')));
        expect(call, throwsA(isA<ServerException>()));
      });
    });
  });
}
