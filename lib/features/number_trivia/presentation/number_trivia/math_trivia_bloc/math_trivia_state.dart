part of 'math_trivia_bloc.dart';

@immutable
abstract class MathTriviaState extends Equatable {
  const MathTriviaState();
}

class MathTriviaInitial extends MathTriviaState {
  @override
  List<Object?> get props => [];
}

class MathTriviaLoading extends MathTriviaState {
  @override
  List<Object?> get props => [];
}

class MathTriviaLoaded extends MathTriviaState {
  final Either<Failure, NumberTrivia> numberTriviaOrFailure;

  const MathTriviaLoaded(this.numberTriviaOrFailure);
  @override
  List<Object?> get props => [numberTriviaOrFailure];
}
