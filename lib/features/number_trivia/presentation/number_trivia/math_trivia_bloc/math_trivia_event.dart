// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'math_trivia_bloc.dart';

@immutable
abstract class MathTriviaEvent extends Equatable {
  const MathTriviaEvent();
}

class GetMathTriviaEvent extends MathTriviaEvent {
  final String input;
  final String languageCode;

  const GetMathTriviaEvent(
    this.input,
    this.languageCode,
  );

  @override
  List<Object?> get props => [input, languageCode];
}

class GetRandomMathTriviaEvent extends MathTriviaEvent {
  final String languageCode;

  const GetRandomMathTriviaEvent(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}
