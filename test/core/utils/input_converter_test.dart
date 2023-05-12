import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/utils/input_converter.dart';

class MockString extends Mock implements InputConverter {}

void main() {
  late MockString mockString;

  setUp(() => mockString = MockString());
  group('InputConverter Method toUnsignedInteger', () {
    test(
        'should return a integer when the string represent a integer that is not negative',
        () async {
      // Arrange
      const str = '123';
      when(
        () => mockString.toUnsignedInteger(str),
      ).thenReturn(const Right(123));
      // Act
      final res = mockString.toUnsignedInteger(str);
      // Assert
      expect(res, equals(const Right(123)));
    });
    test(
        'should return invalidInputFailure when the string represent a integer that is negative',
        () async {
      // Arrange
      const strNeg = '-123';
      when(
        () => mockString.toUnsignedInteger(strNeg),
      ).thenReturn(Left(InvalidInputFailure()));
      // Act
      final res1 = mockString.toUnsignedInteger(strNeg);
      // Assert
      expect(res1, equals(Left(InvalidInputFailure())));
    });
    test(
        'should return a invalidInputFailure when the string does not represent an integer',
        () async {
      // Arrange
      const str = 'abc';
      when(
        () => mockString.toUnsignedInteger(str),
      ).thenReturn(Left(InvalidInputFailure()));
      // Act
      final res = mockString.toUnsignedInteger(str);
      // Assert
      expect(res, equals(Left(InvalidInputFailure())));
    });
  });
}
