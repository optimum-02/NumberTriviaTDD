import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/use_cases/usecases.dart';
import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/number_trivia/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  late NumberTriviaBloc numberTriviaBloc;
  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  final tNumberTrivia = NumberTrivia(number: 1, text: "test text");

  group('GetNumberTriviaBloc', () {
    const tNumberString = '1';
    const tNumber = 1;
    test('should emit and initital', () async {
      // Arrange

      // Act

      // Assert
      expect(numberTriviaBloc.state, NumberTriviaInitial());
    });

    test('should emit failure state when the input conversion fail', () async {
      // Arrange
      when(() => mockInputConverter.toUnsignedInteger(tNumberString))
          .thenReturn(Left(InvalidInputFailure()));
      // Act
      numberTriviaBloc.add(const GetConcreteNumberTriviaEvent(tNumberString));
      // Assert

      await expectLater(
        numberTriviaBloc.stream,
        emitsInOrder([
          NumberTriviaLoaded(Left(InvalidInputFailure())),
        ]),
      );
      verify(
        () => mockInputConverter.toUnsignedInteger(tNumberString),
      ).called(1);
      verifyZeroInteractions(mockGetConcreteNumberTrivia);
      verifyNoMoreInteractions(mockInputConverter);
    });

    test(
        'should emit Loading and Loaded(Right(NumberTrivia))  when call to the usecase success',
        () async {
      // Arrange
      when(() => mockInputConverter.toUnsignedInteger(tNumberString))
          .thenReturn(right(1));
      when(
        () => mockGetConcreteNumberTrivia(
            const ConcreteNumberTriviaParams(number: tNumber)),
      ).thenAnswer((_) async => right(tNumberTrivia));
      // Act
      numberTriviaBloc.add(const GetConcreteNumberTriviaEvent(tNumberString));
      // Assert
      await expectLater(
        numberTriviaBloc.stream,
        emitsInOrder([
          NumberTriviaLoading(),
          NumberTriviaLoaded(Right(tNumberTrivia)),
        ]),
      );
      verify(
        () => mockGetConcreteNumberTrivia(
            const ConcreteNumberTriviaParams(number: tNumber)),
      ).called(1);
    });
    test(
        'should emit [Loading and Loaded(Left(Failure))] when call to the usecase fail',
        () async {
      // Arrange
      when(() => mockInputConverter.toUnsignedInteger(tNumberString))
          .thenReturn(right(1));
      when(
        () => mockGetConcreteNumberTrivia(
            const ConcreteNumberTriviaParams(number: tNumber)),
      ).thenAnswer((_) async => left(ServerFailure()));
      // Act
      numberTriviaBloc.add(const GetConcreteNumberTriviaEvent(tNumberString));
      // Assert
      await expectLater(
        numberTriviaBloc.stream,
        emitsInOrder([
          NumberTriviaLoading(),
          NumberTriviaLoaded(Left(ServerFailure())),
        ]),
      );
      verify(
        () => mockGetConcreteNumberTrivia(
            const ConcreteNumberTriviaParams(number: tNumber)),
      ).called(1);
    });
  });
  group('GetRandomNumberTriviaBloc', () {
    test('should emit and initital', () async {
      // Arrange

      // Act

      // Assert
      expect(numberTriviaBloc.state, NumberTriviaInitial());
    });

    test(
        'should emit Loading and Loaded(Right(NumberTrivia))  when call to the usecase success',
        () async {
      // Arrange

      when(
        () => mockGetRandomNumberTrivia(NoParams()),
      ).thenAnswer((_) async => right(tNumberTrivia));
      // Act
      numberTriviaBloc.add(const GetRandomNumberTriviaEvent());
      // Assert
      await expectLater(
        numberTriviaBloc.stream,
        emitsInOrder([
          NumberTriviaLoading(),
          NumberTriviaLoaded(Right(tNumberTrivia)),
        ]),
      );
      verify(
        () => mockGetRandomNumberTrivia(NoParams()),
      ).called(1);
    });
    test(
        'should emit [Loading and Loaded(Left(ServerFailure))] when call to the usecase fail',
        () async {
      // Arrange
      final Future<Either<Failure, NumberTrivia>> failure =
          Future.value(left(ServerFailure()));
      when(
        () => mockGetRandomNumberTrivia(NoParams()),
      ).thenAnswer((_) => failure);
      // Act
      numberTriviaBloc.add(const GetRandomNumberTriviaEvent());
      // Assert
      await expectLater(
        numberTriviaBloc.stream,
        emitsInOrder([
          NumberTriviaLoading(),
          NumberTriviaLoaded(await failure), //reference equality here
        ]),
      );
      verify(
        () => mockGetRandomNumberTrivia(NoParams()),
      ).called(1);
    });
  });
}
