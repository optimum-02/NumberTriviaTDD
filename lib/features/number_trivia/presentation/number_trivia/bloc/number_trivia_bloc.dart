import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:number_trivia/core/utils/input_converter.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/use_cases/usecases.dart';
import '../../../domain/entities/number_trivia.dart';
import '../../../domain/use_cases/get_concrete_number_trivia.dart';
import '../../../domain/use_cases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(
          NumberTriviaInitial(),
        ) {
    on<GetConcreteNumberTriviaEvent>((event, emit) async {
      final number = inputConverter.toUnsignedInteger(event.input);
      print(number);

      if (number.isLeft()) {
        emit(NumberTriviaLoaded(Left(InvalidInputFailure())));
      }
      if (number.isRight()) {
        emit(NumberTriviaLoading());
        final result = await getConcreteNumberTrivia(ConcreteNumberTriviaParams(
            number: number.getOrElse(() => throw Error())));

        emit(NumberTriviaLoaded(result));
      }
    });
    on<GetRandomNumberTriviaEvent>((event, emit) async {
      emit(NumberTriviaLoading());
      final result = await getRandomNumberTrivia(NoParams());
      emit(NumberTriviaLoaded(result));
    });
  }
}
