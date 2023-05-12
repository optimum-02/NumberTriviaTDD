import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/usecases.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia
    implements UseCases<NumberTrivia, ConcreteNumberTriviaParams> {
  final NumberTriviaRepository numberTriviaRepository;
  GetConcreteNumberTrivia(
    this.numberTriviaRepository,
  );

  @override
  Future<Either<Failure, NumberTrivia>> call(
      ConcreteNumberTriviaParams params) async {
    return await numberTriviaRepository.getConcreteNumberTrivia(params.number);
  }
}

class ConcreteNumberTriviaParams extends Params {
  final int number;

  const ConcreteNumberTriviaParams({required this.number}) : super();

  @override
  List<Object?> get props => [number];
}
