// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/usecases.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetMathTrivia implements UseCases<NumberTrivia, MathTriviaParams> {
  final NumberTriviaRepository numberTriviaRepository;
  GetMathTrivia(
    this.numberTriviaRepository,
  );

  @override
  Future<Either<Failure, NumberTrivia>> call(MathTriviaParams params) async {
    return await numberTriviaRepository.getMathTrivia(
        params.number, params.languageCode);
  }
}

class MathTriviaParams extends Params {
  final int number;
  final String languageCode;

  const MathTriviaParams({
    required this.number,
    required this.languageCode,
  }) : super();

  @override
  List<Object?> get props => [number, languageCode];
}
