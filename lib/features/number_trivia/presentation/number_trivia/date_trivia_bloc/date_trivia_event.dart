part of 'date_trivia_bloc.dart';

@immutable
abstract class DateTriviaEvent extends Equatable {
  const DateTriviaEvent();
}

class GetDateTriviaEvent extends DateTriviaEvent {
  final DateTime dateInput;
  final String languageCode;

  const GetDateTriviaEvent(
    this.dateInput,
    this.languageCode,
  );

  @override
  List<Object?> get props => [dateInput, languageCode];
}

class GetRandomDateTriviaEvent extends DateTriviaEvent {
  final String languageCode;

  const GetRandomDateTriviaEvent(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}
