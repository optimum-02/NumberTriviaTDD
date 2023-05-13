import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';

class MockNumberTriviRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviRepository mockNumberTriviRepository;

  setUp(() {
    mockNumberTriviRepository = MockNumberTriviRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviRepository);
  });

  const tNumberTrivia = NumberTrivia(number: 1, text: "Test text");
  test('should get trivia from repository', () async {
    //arange
    when(() => mockNumberTriviRepository.getRandomNumberTrivia(any()))
        .thenAnswer((_) async => right(tNumberTrivia));

    //act
    final result =
        await usecase(const RandomNumberTriviaParams(languageCode: 'en'));
    //assets
    expect(result, equals(right(tNumberTrivia)));
    verify(
      () => mockNumberTriviRepository.getRandomNumberTrivia('en'),
    ).called(1);
  });
}
