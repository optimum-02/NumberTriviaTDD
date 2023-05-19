import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/usecases.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomDateTrivia
    implements UseCases<NumberTrivia, RandomDateTriviaParams> {
  final NumberTriviaRepository numberTriviaRepository;
  GetRandomDateTrivia(
    this.numberTriviaRepository,
  );

  @override
  Future<Either<Failure, NumberTrivia>> call(
      RandomDateTriviaParams params) async {
    return await numberTriviaRepository
        .getRandomDateTrivia(params.languageCode);
  }
}

class RandomDateTriviaParams extends Params {
  final String languageCode;

  const RandomDateTriviaParams({
    required this.languageCode,
  }) : super();

  @override
  List<Object?> get props => [languageCode];
}
