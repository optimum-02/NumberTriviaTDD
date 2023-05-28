part of 'number_trivia_bloc.dart';

@immutable
abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

class NumberTriviaInitial extends NumberTriviaState {
  @override
  List<Object?> get props => [];
}

class NumberTriviaLoading extends NumberTriviaState {
  @override
  List<Object?> get props => [];
}

class NumberTriviaLoaded extends NumberTriviaState {
  final Either<Failure, NumberTrivia> numberTriviaOrFailure;

  const NumberTriviaLoaded(this.numberTriviaOrFailure);
  @override
  List<Object?> get props => [numberTriviaOrFailure];
}
