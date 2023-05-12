import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture.dart';

class MockHttpClient extends Mock implements Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late NumberTriviaRemoteDataSourceImpl numberTriviaRemoteDataSourceImpl;

  setUp(() => {
        mockHttpClient = MockHttpClient(),
        numberTriviaRemoteDataSourceImpl =
            NumberTriviaRemoteDataSourceImpl(mockHttpClient),
      });

  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test text");
  final request =
      mockHttpClient.get(Uri.parse(any()), headers: any(named: "header"));

  group('Get Concrete NumberTrivia', () {
    test(
        'should return NumberTriviaModel from the provided url when the request succeeded with the status code of 200',
        () async {
      // Arrange
      when(
        () => request,
      ).thenAnswer(
          (_) async => Response(await reader("number_trivia.json"), 200));
      // Act
      final result =
          await numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia(1);
      // Assert
      expect(result, tNumberTriviaModel);
      verify(() => request).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });

    test(
        'should return server exception request succeeded with the status code different from 200',
        () async {
      // Arrange
      when(() => request).thenAnswer((invocation) async => Response("", 404));
      // Act
      final result =
          numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia(1);
      // Assert
      await expectLater(result, throwsA(isA<ServerException>()));
      verify(() => request).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });
  });
  group('Get Random NumberTrivia', () {
    test(
        'should return NumberTriviaModel from the provided url when the request succeeded with the status code of 200',
        () async {
      // Arrange
      when(() => request).thenAnswer(
          (_) async => Response(await reader("number_trivia.json"), 200));
      // Act
      final result =
          await numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia();
      // Assert
      expect(result, tNumberTriviaModel);
      verify(() => request).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });

    test(
        'should return server exception request succeeded with the status code different from 200',
        () async {
      // Arrange
      when(() => request).thenAnswer((_) async => Response("", 404));
      // Act
      final result = numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia();
      // Assert
      await expectLater(result, throwsA(isA<ServerException>()));
      verify(() => request).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });
  });
}
