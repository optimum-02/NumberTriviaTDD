part of 'number_trivia_bloc.dart';

@immutable
abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

class GetConcreteNumberTriviaEvent extends NumberTriviaEvent {
  final String input;

  const GetConcreteNumberTriviaEvent(this.input);

  @override
  List<Object?> get props => [input];
}

class GetRandomNumberTriviaEvent extends NumberTriviaEvent {
  const GetRandomNumberTriviaEvent();

  @override
  List<Object?> get props => [];
}
