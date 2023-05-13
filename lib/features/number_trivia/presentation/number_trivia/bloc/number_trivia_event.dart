// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'number_trivia_bloc.dart';

@immutable
abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

class GetConcreteNumberTriviaEvent extends NumberTriviaEvent {
  final String input;
  final String languageCode;

  const GetConcreteNumberTriviaEvent(
    this.input,
    this.languageCode,
  );

  @override
  List<Object?> get props => [input, languageCode];
}

class GetRandomNumberTriviaEvent extends NumberTriviaEvent {
  final String languageCode;

  const GetRandomNumberTriviaEvent(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}
