import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviRepository;

  setUp(() {
    mockNumberTriviRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviRepository);
  });

  const tNumberTrivia = NumberTrivia(number: 1, text: "Test text");
  const tNumber = 1;
  test('should get trivia from repository for a number', () async {
    //arange
    when(() => mockNumberTriviRepository.getConcreteNumberTrivia(any()))
        .thenAnswer((_) async => right(tNumberTrivia));

    //act
    final result = await usecase(const ConcreteNumberTriviaParams(number: 1));
    //assets
    expect(result, equals(right(tNumberTrivia)));
    verify(
      () => mockNumberTriviRepository.getConcreteNumberTrivia(tNumber),
    ).called(1);
  });
}
