import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:number_trivia/core/utils/input_converter.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/number_trivia.dart';
import '../../../domain/use_cases/get_math_trivia.dart';
import '../../../domain/use_cases/get_random_math_trivia.dart';

part 'math_trivia_event.dart';
part 'math_trivia_state.dart';

class MathTriviaBloc extends Bloc<MathTriviaEvent, MathTriviaState> {
  final GetMathTrivia getMathTrivia;
  final GetRandomMathTrivia getRandomMathTrivia;
  final InputConverter inputConverter;
  MathTriviaBloc({
    required this.getMathTrivia,
    required this.getRandomMathTrivia,
    required this.inputConverter,
  }) : super(
          MathTriviaInitial(),
        ) {
    on<GetMathTriviaEvent>((event, emit) async {
      final number = inputConverter.toUnsignedInteger(event.input);

      if (number.isLeft()) {
        emit(MathTriviaLoaded(Left(InvalidInputFailure())));
      }
      if (number.isRight()) {
        emit(MathTriviaLoading());
        final result = await getMathTrivia(MathTriviaParams(
          number: number.getOrElse(() => throw Error()),
          languageCode: event.languageCode,
        ));

        emit(MathTriviaLoaded(result));
      }
    });
    on<GetRandomMathTriviaEvent>((event, emit) async {
      emit(MathTriviaLoading());
      final result = await getRandomMathTrivia(
          RandomMathTriviaParams(languageCode: event.languageCode));
      emit(MathTriviaLoaded(result));
    });
  }
}
