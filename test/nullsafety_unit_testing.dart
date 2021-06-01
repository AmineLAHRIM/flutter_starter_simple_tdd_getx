import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'nullsafety_unit_testing.mocks.dart';

class Cat {
  Future<String> chew(String txt) async => Future.value(txt);
}

class MockMethodChannel extends Mock implements MethodChannel {
  @override
  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) async {
    return super.noSuchMethod(Invocation.method(#invokeMethod, [method, arguments])) as dynamic;
  }
}

//class MockCat extends Mock implements Cat {}

@GenerateMocks([Cat])
void main() {
  final Cat cat = MockCat();
  final name='hello';

  test('should return when call [chew]', () async{
    when(cat.chew(name))
        .thenAnswer((_) async => name);

    final result = await cat.chew(name);
    // ASSERT
    //verify(mockDio!.post(REST_API, data: userSignUp));
    expect(result, name);
  });
}