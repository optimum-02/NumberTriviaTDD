import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDataSource =
        NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "test text");
  final jsonNumberTrivia = jsonEncode(tNumberTriviaModel.toJson());

  group('Get NumberTriviaModel', () {
    test(
        'should return NumberTriviaModel from the SharedPrefrences when there is one on',
        () async {
      // Arrange
      when(
        () => mockSharedPreferences.getString(cachedNumberTriviaKey),
      ).thenReturn(jsonNumberTrivia);
      // Act
      final result = await numberTriviaLocalDataSource.getCachedNumberTrivia();
      // Assert
      expect(result, tNumberTriviaModel);
    });
    test('should return NoCahedNumberTriviaException  when there is none',
        () async {
      // Arrange
      when(
        () => mockSharedPreferences.getString(cachedNumberTriviaKey),
      ).thenReturn(null);
      // Act
      final result = numberTriviaLocalDataSource.getCachedNumberTrivia();
      // Assert

      await expectLater(result, throwsA(isA<NoCachedNumberTriviaException>()));
    });
  });

  group('CacheNumberTrivia', () {
    test(
        'should foward call to SharedPreferenced.setString() with a NumberTriviaModel provided',
        () async {
      // Arrange
      when(
        () => mockSharedPreferences.setString(
            cachedNumberTriviaKey, jsonNumberTrivia),
      ).thenAnswer((_) async => true);
      // Act
      numberTriviaLocalDataSource.cacheNumberTrivia(tNumberTriviaModel);
      // Assert
      verify(
        () => mockSharedPreferences.setString(
            cachedNumberTriviaKey, jsonNumberTrivia),
      ).called(1);
      verifyNoMoreInteractions(mockSharedPreferences);
    });
  });
}
