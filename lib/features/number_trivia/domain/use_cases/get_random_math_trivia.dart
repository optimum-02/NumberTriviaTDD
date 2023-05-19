import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/usecases.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomMathTrivia
    implements UseCases<NumberTrivia, RandomMathTriviaParams> {
  final NumberTriviaRepository numberTriviaRepository;
  GetRandomMathTrivia(
    this.numberTriviaRepository,
  );

  @override
  Future<Either<Failure, NumberTrivia>> call(
      RandomMathTriviaParams params) async {
    return await numberTriviaRepository
        .getRandomMathTrivia(params.languageCode);
  }
}

class RandomMathTriviaParams extends Params {
  final String languageCode;

  const RandomMathTriviaParams({
    required this.languageCode,
  }) : super();

  @override
  List<Object?> get props => [languageCode];
}
