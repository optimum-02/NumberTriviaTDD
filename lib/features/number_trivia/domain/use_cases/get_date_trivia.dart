// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/usecases.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetDateTrivia implements UseCases<NumberTrivia, DateTriviaParams> {
  final NumberTriviaRepository numberTriviaRepository;
  GetDateTrivia(
    this.numberTriviaRepository,
  );

  @override
  Future<Either<Failure, NumberTrivia>> call(DateTriviaParams params) async {
    return await numberTriviaRepository.getDateTrivia(
        params.month, params.day, params.languageCode);
  }
}

class DateTriviaParams extends Params {
  final int month;
  final int day;
  final String languageCode;

  const DateTriviaParams({
    required this.month,
    required this.day,
    required this.languageCode,
  }) : super();

  @override
  List<Object?> get props => [month, day, languageCode];
}
