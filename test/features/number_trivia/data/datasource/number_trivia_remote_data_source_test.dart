import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture.dart';

class MockHttpClient extends Mock implements Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late MockHttpClient mockHttpClient;
  late NumberTriviaRemoteDataSourceImpl numberTriviaRemoteDataSourceImpl;
  // late Future<Response> request;
  setUp(() {
    mockHttpClient = MockHttpClient();
    numberTriviaRemoteDataSourceImpl =
        NumberTriviaRemoteDataSourceImpl(mockHttpClient);
  });
  registerFallbackValue(FakeUri());
  // final request = mockHttpClient.get(any(), headers: any(named: "header"));

  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test text");
  // final request =
  //     mockHttpClient.get(Uri.parse(any()), headers: any(named: "header"));

  group('Get Concrete NumberTrivia', () {
    test(
        'should return NumberTriviaModel from the provided url when the request succeeded with the status code of 200',
        () async {
      // Arrange
      when(
        () => mockHttpClient.get(any(), headers: any(named: "headers")),
      ).thenAnswer(
          (_) async => Response(await reader("number_trivia.json"), 200));
      // Act
      final result =
          await numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia(1);
      // Assert
      expect(result, tNumberTriviaModel);
      verify(
        () => mockHttpClient.get(any(), headers: any(named: "headers")),
      ).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });

    test(
        'should throw server exception request succeeded with the status code different from 200',
        () async {
      // Arrange
      when(() => mockHttpClient.get(any(), headers: any(named: "headers")))
          .thenAnswer((_) async => Response("", 404));
      // Act
      final result =
          numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia(1);
      // Assert
      await expectLater(result, throwsA(isA<ServerException>()));
      verify(() => mockHttpClient.get(any(), headers: any(named: "headers")))
          .called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });
  });
  group('Get Random NumberTrivia', () {
    test(
        'should return NumberTriviaModel from the provided url when the mockHttpClient.get(any(), headers: any(named: "header")) succeeded with the status code of 200',
        () async {
      // Arrange
      when(() => mockHttpClient.get(any(), headers: any(named: "headers")))
          .thenAnswer(
              (_) async => Response(await reader("number_trivia.json"), 200));
      // Act
      final result =
          await numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia();
      // Assert
      expect(result, tNumberTriviaModel);
      verify(() => mockHttpClient.get(any(), headers: any(named: "headers")))
          .called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });

    test(
        'should throw server exception request succeeded with the status code different from 200',
        () async {
      // Arrange
      when(() => mockHttpClient.get(any(), headers: any(named: "headers")))
          .thenAnswer((_) async => Response("", 404));
      // Act
      final result = numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia();
      // Assert
      await expectLater(result, throwsA(isA<ServerException>()));
      verify(() => mockHttpClient.get(any(), headers: any(named: "headers")))
          .called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });
  });
}
