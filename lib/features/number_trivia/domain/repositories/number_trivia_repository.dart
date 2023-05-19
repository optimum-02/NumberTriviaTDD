import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number, String languageCode);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia(
      String languageCode);
  Future<Either<Failure, NumberTrivia>> getMathTrivia(
      int number, String languageCode);
  Future<Either<Failure, NumberTrivia>> getRandomMathTrivia(
      String languageCode);
  Future<Either<Failure, NumberTrivia>> getDateTrivia(
      int month, int day, String languageCode);
  Future<Either<Failure, NumberTrivia>> getRandomDateTrivia(
      String languageCode);
}
