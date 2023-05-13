import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test text");

  test('should be a sub class of [NumberTrivia]', () {
    //arrange

    //act

    //asset
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  test(
      'Should return a valid NumberTriviaModel from the json map string provided',
      () async {
    // Arrange
    final jsonMapDouble = jsonDecode(await reader("number_trivia_double.json"))
        as Map<String, dynamic>;
    final jsonMapInt =
        jsonDecode(await reader("number_trivia.json")) as Map<String, dynamic>;

    // Act
    final resultDouble = NumberTriviaModel.fromJson(jsonMapDouble);
    final result = NumberTriviaModel.fromJson(jsonMapInt);

    // Assert
    expect(result, tNumberTriviaModel);
    expect(resultDouble, tNumberTriviaModel);
  });

  test('Should return a json map  from a NumberTriviaModel  provided',
      () async {
    // Arrange

    // Act
    final result = tNumberTriviaModel.toJson();

    // Assert
    final json = {"number": 1, "text": "Test text"};
    expect(result, json);
  });
}
