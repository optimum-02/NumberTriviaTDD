import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number, String languageCode);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia(
      String languageCode);
}
