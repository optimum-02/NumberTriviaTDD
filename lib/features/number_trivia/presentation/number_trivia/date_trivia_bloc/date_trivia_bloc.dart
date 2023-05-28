import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:number_trivia/core/utils/input_converter.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/number_trivia.dart';
import '../../../domain/use_cases/get_date_trivia.dart';
import '../../../domain/use_cases/get_random_date_trivia.dart';

part 'date_trivia_event.dart';
part 'date_trivia_state.dart';

class DateTriviaBloc extends Bloc<DateTriviaEvent, DateTriviaState> {
  final GetDateTrivia getDateTrivia;
  final GetRandomDateTrivia getRandomDateTrivia;
  final InputConverter inputConverter;
  DateTriviaBloc({
    required this.getDateTrivia,
    required this.getRandomDateTrivia,
    required this.inputConverter,
  }) : super(
          DateTriviaInitial(),
        ) {
    on<GetDateTriviaEvent>((event, emit) async {
      final dateInput = event.dateInput;

      emit(DateTriviaLoading());
      final result = await getDateTrivia(DateTriviaParams(
        month: dateInput.month,
        day: dateInput.day,
        languageCode: event.languageCode,
      ));

      emit(DateTriviaLoaded(result));
    });
    on<GetRandomDateTriviaEvent>((event, emit) async {
      emit(DateTriviaLoading());
      final result = await getRandomDateTrivia(
          RandomDateTriviaParams(languageCode: event.languageCode));
      emit(DateTriviaLoaded(result));
    });
  }
}
