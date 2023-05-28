part of 'date_trivia_bloc.dart';

@immutable
abstract class DateTriviaState extends Equatable {
  const DateTriviaState();
}

class DateTriviaInitial extends DateTriviaState {
  @override
  List<Object?> get props => [];
}

class DateTriviaLoading extends DateTriviaState {
  @override
  List<Object?> get props => [];
}

class DateTriviaLoaded extends DateTriviaState {
  final Either<Failure, NumberTrivia> numberTriviaOrFailure;

  const DateTriviaLoaded(this.numberTriviaOrFailure);
  @override
  List<Object?> get props => [numberTriviaOrFailure];
}
