import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/platform/language_infos.dart';
import 'package:number_trivia/core/platform/network_infos.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class MockNumberTriviaLocalDataSource extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNumberTriviaRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNetworkInfos extends Mock implements NetworkInfos {}

class MockTransaltion extends Mock implements Translation {}

void main() {
  late NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;
  late MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  late MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  late MockTransaltion mockTransaltion;
  late MockNetworkInfos mockNetworkInfos;
  late NumberTriviaModel tNumberTriviaModel;
  late NumberTrivia tNumberTrivia;
  const lang = "fr";

  setUp(() {
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNetworkInfos = MockNetworkInfos();
    mockTransaltion = MockTransaltion();
    numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
      remoteDataSource: mockNumberTriviaRemoteDataSource,
      localDataSource: mockNumberTriviaLocalDataSource,
      networkInfos: mockNetworkInfos,
      translation: mockTransaltion,
    );
    tNumberTriviaModel = const NumberTriviaModel(number: 1, text: "test text");
    tNumberTrivia = tNumberTriviaModel;
  });

  group('GetConcreteNumberTrivia', () {
    const tNumber = 1;
    test('should check internet connection', () async {
      // Arrange
      when(() => mockNetworkInfos.checkConnection())
          .thenAnswer((_) async => true);
      when(() =>
              mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockNumberTriviaLocalDataSource
          .cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => {});
      when(
        () => mockTransaltion.translate(
            text: tNumberTriviaModel.text,
            targetLanguageCode: lang,
            sourceLanguageCode: "en"),
      ).thenAnswer((_) async => tNumberTriviaModel.text);
      // Act
      await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber, lang);
      // Assert
      verify(() => mockNetworkInfos.checkConnection()).called(1);
    });

    group('device online', () {
      setUp(
        () => when(() => mockNetworkInfos.checkConnection())
            .thenAnswer((_) async => true),
      );

      test("""should return NumberTrivia from remote data source
      when a remote data number trivia call is successful
      cache the number trivia
      and translation into the language when the user language is not english also success""",
          () async {
        // Arrange
        when(() => mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(
            tNumber)).thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockNumberTriviaLocalDataSource
            .cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => {});
        when(
          () => mockTransaltion.translate(
              text: tNumberTriviaModel.text,
              targetLanguageCode: lang,
              sourceLanguageCode: "en"),
        ).thenAnswer((_) async => tNumberTriviaModel.text);
        // Act
        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(
            tNumber, lang);
        // Assert

        expect(result, equals(Right(tNumberTrivia)));
        verify(
          () {
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber);
          },
        ).called(1);
        verify(
          () {
            mockNumberTriviaLocalDataSource
                .cacheNumberTrivia(tNumberTriviaModel);
          },
        ).called(1);
        verify(
          () {
            mockTransaltion.translate(
                text: tNumberTriviaModel.text,
                targetLanguageCode: lang,
                sourceLanguageCode: "en");
          },
        ).called(1);
      });

      test(
          'should return a server failure when a remote data number trivia call is unsuccessful',
          () async {
        // Arrange
        when(() => mockNetworkInfos.checkConnection())
            .thenAnswer((_) async => true);
        when(
          () =>
              mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber),
        ).thenThrow(ServerException());
        // Act
        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(
            tNumber, lang);
        // Assert

        expect(result, equals(Left(ServerFailure())));
        verify(
          () {
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber);
          },
        ).called(1);
        verifyNoMoreInteractions(mockNumberTriviaLocalDataSource);
        verifyZeroInteractions(mockTransaltion);
      });
      test(
          'should return a translation failure when a remote data number trivia call is successful but the call to translation.translate() fail',
          () async {
        // Arrange
        when(() => mockNetworkInfos.checkConnection())
            .thenAnswer((_) async => true);
        when(() => mockNumberTriviaLocalDataSource
            .cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => {});
        when(
          () =>
              mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber),
        ).thenAnswer((_) async => (tNumberTriviaModel));

        when(
          () => mockTransaltion.translate(
              text: tNumberTriviaModel.text,
              targetLanguageCode: lang,
              sourceLanguageCode: "en"),
        ).thenThrow(TranslationFailedException());
        // Act
        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(
            tNumber, lang);
        // Assert

        expect(result, equals(Left(TransalationFailedFailure())));
        verify(
          () {
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber);
          },
        ).called(1);
        verify(
          () {
            mockNumberTriviaLocalDataSource
                .cacheNumberTrivia(tNumberTriviaModel);
          },
        ).called(1);
        verify(
          () {
            mockTransaltion.translate(
                text: tNumberTriviaModel.text,
                targetLanguageCode: lang,
                sourceLanguageCode: "en");
          },
        ).called(1);
      });
    });
    group('device offline', () {
      setUp(
        () => when(() => mockNetworkInfos.checkConnection())
            .thenAnswer((_) async => false),
      );
      test("should return NumberTrivia from local data source", () async {
        // Arrange

        when(() => mockNumberTriviaLocalDataSource.getCachedNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        // Act
        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(
            tNumber, lang);
        // Assert

        expect(result, equals(Right(tNumberTrivia)));
        verify(
          () {
            mockNumberTriviaLocalDataSource.getCachedNumberTrivia();
          },
        ).called(1);

        verifyNoMoreInteractions(mockNumberTriviaLocalDataSource);
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verifyZeroInteractions(mockTransaltion);
      });

      test(
          'should return a NoCachedDataFailure when there is no cached data present',
          () async {
        // Arrange

        when(
          () => mockNumberTriviaLocalDataSource.getCachedNumberTrivia(),
        ).thenThrow(NoCachedNumberTriviaException());
        // Act
        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(
            tNumber, "en");
        // Assert

        verify(
          () {
            mockNumberTriviaLocalDataSource.getCachedNumberTrivia();
          },
        ).called(1);
        verifyNoMoreInteractions(mockNumberTriviaLocalDataSource);
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verifyZeroInteractions(mockTransaltion);
        expect(result, equals(Left(NoCachedDataFailure())));
      });
    });
  });
  group('GetRandomNumberTrivia', () {
    test('should check internet connection', () async {
      // Arrange
      when(() => mockNetworkInfos.checkConnection())
          .thenAnswer((_) async => true);
      when(() => mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockNumberTriviaLocalDataSource
          .cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => {});
      when(
        () => mockTransaltion.translate(
            text: tNumberTriviaModel.text,
            targetLanguageCode: lang,
            sourceLanguageCode: "en"),
      ).thenAnswer((_) async => tNumberTriviaModel.text);
      // Act
      await numberTriviaRepositoryImpl.getRandomNumberTrivia(lang);
      // Assert
      verify(() => mockNetworkInfos.checkConnection()).called(1);
    });

    group('device online', () {
      setUp(
        () => when(() => mockNetworkInfos.checkConnection())
            .thenAnswer((_) async => true),
      );
      test(
          """should return NumberTrivia and cache it when a remote data number trivia call is successful and the trnsaltion call also success in case lang!="en"
          """, () async {
        // Arrange
        when(
          () => mockTransaltion.translate(
              text: tNumberTriviaModel.text,
              targetLanguageCode: lang,
              sourceLanguageCode: "en"),
        ).thenAnswer((_) async => tNumberTriviaModel.text);
        when(() => mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockNumberTriviaLocalDataSource
            .cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => {});

        // Act
        final result =
            await numberTriviaRepositoryImpl.getRandomNumberTrivia(lang);

        // Assert

        expect(result, equals(Right(tNumberTrivia)));
        verify(
          () {
            mockNumberTriviaRemoteDataSource.getRandomNumberTrivia();
          },
        ).called(1);
        verify(
          () {
            mockNumberTriviaLocalDataSource
                .cacheNumberTrivia(tNumberTriviaModel);
          },
        ).called(1);
        verifyNoMoreInteractions(mockNumberTriviaLocalDataSource);
        verifyNoMoreInteractions(mockNumberTriviaRemoteDataSource);
        verify(
          () {
            mockTransaltion.translate(
                text: tNumberTriviaModel.text,
                targetLanguageCode: lang,
                sourceLanguageCode: "en");
          },
        ).called(1);
      });

      test(
          'should return a server failure when a remote data number trivia call is unsuccessful',
          () async {
        // Arrange

        when(
          () => mockNumberTriviaRemoteDataSource.getRandomNumberTrivia(),
        ).thenThrow(ServerException());
        // Act
        final result =
            await numberTriviaRepositoryImpl.getRandomNumberTrivia(lang);
        // Assert

        expect(result, equals(Left(ServerFailure())));
        verify(
          () {
            mockNumberTriviaRemoteDataSource.getRandomNumberTrivia();
          },
        ).called(1);
        verifyZeroInteractions(mockNumberTriviaLocalDataSource);
        verifyNoMoreInteractions(mockNumberTriviaRemoteDataSource);
        verifyZeroInteractions(mockTransaltion);
      });
      test(
          'should return a translation failure when a remote data number trivia call is successful but the call to translation.translate() fail',
          () async {
        // Arrange
        when(() => mockNetworkInfos.checkConnection())
            .thenAnswer((_) async => true);
        when(() => mockNumberTriviaLocalDataSource
            .cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => {});
        when(
          () => mockNumberTriviaRemoteDataSource.getRandomNumberTrivia(),
        ).thenAnswer((_) async => tNumberTriviaModel);

        when(
          () => mockTransaltion.translate(
              text: tNumberTriviaModel.text,
              targetLanguageCode: lang,
              sourceLanguageCode: "en"),
        ).thenThrow(TranslationFailedException());
        // Act
        final result =
            await numberTriviaRepositoryImpl.getRandomNumberTrivia(lang);
        // Assert

        expect(result, equals(Left(TransalationFailedFailure())));
        verify(
          () {
            mockNumberTriviaRemoteDataSource.getRandomNumberTrivia();
          },
        ).called(1);
        verify(
          () {
            mockNumberTriviaLocalDataSource
                .cacheNumberTrivia(tNumberTriviaModel);
          },
        ).called(1);
        verify(
          () {
            mockTransaltion.translate(
                text: tNumberTriviaModel.text,
                targetLanguageCode: lang,
                sourceLanguageCode: "en");
          },
        ).called(1);
      });
    });
    group('device offline', () {
      setUp(
        () => when(() => mockNetworkInfos.checkConnection())
            .thenAnswer((_) async => false),
      );
      test("should return NumberTrivia from local data source", () async {
        // Arrange

        when(() => mockNumberTriviaLocalDataSource.getCachedNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        // Act
        final result =
            await numberTriviaRepositoryImpl.getRandomNumberTrivia(lang);
        // Assert

        expect(result, equals(Right(tNumberTrivia)));
        verify(
          () {
            mockNumberTriviaLocalDataSource.getCachedNumberTrivia();
          },
        ).called(1);

        verifyNoMoreInteractions(mockNumberTriviaLocalDataSource);
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verifyZeroInteractions(mockTransaltion);
      });

      test(
          'should return a NoCachedDataFailure when a there is no cahed data present',
          () async {
        // Arrange

        when(
          () => mockNumberTriviaLocalDataSource.getCachedNumberTrivia(),
        ).thenThrow(NoCachedNumberTriviaException());
        // Act
        final result =
            await numberTriviaRepositoryImpl.getRandomNumberTrivia(lang);
        // Assert

        verify(
          () {
            mockNumberTriviaLocalDataSource.getCachedNumberTrivia();
          },
        ).called(1);
        verifyNoMoreInteractions(mockNumberTriviaLocalDataSource);
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verifyZeroInteractions(mockTransaltion);
        expect(result, equals(Left(NoCachedDataFailure())));
      });
    });
  });
}
