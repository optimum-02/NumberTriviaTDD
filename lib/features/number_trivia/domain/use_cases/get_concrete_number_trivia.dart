// ignore_for_file: public_member_api_docs, sort_constructors_first
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
    return await numberTriviaRepository.getConcreteNumberTrivia(
        params.number, params.languageCode);
  }
}

class ConcreteNumberTriviaParams extends Params {
  final int number;
  final String languageCode;

  const ConcreteNumberTriviaParams({
    required this.number,
    required this.languageCode,
  }) : super();

  @override
  List<Object?> get props => [number, languageCode];
}
