import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/usecases.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia
    implements UseCases<NumberTrivia, RandomNumberTriviaParams> {
  final NumberTriviaRepository numberTriviaRepository;
  GetRandomNumberTrivia(
    this.numberTriviaRepository,
  );

  @override
  Future<Either<Failure, NumberTrivia>> call(
      RandomNumberTriviaParams params) async {
    return await numberTriviaRepository
        .getRandomNumberTrivia(params.languageCode);
  }
}

class RandomNumberTriviaParams extends Params {
  final String languageCode;

  const RandomNumberTriviaParams({
    required this.languageCode,
  }) : super();

  @override
  List<Object?> get props => [languageCode];
}
