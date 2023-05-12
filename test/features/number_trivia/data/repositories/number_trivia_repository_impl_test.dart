import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/core/errors/failures.dart';
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

void main() {
  late NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;
  late MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  late MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  late MockNetworkInfos mockNetworkInfos;
  late NumberTriviaModel tNumberTriviaModel;
  late NumberTrivia tNumberTrivia;

  setUp(() {
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNetworkInfos = MockNetworkInfos();
    numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
      remoteDataSource: mockNumberTriviaRemoteDataSource,
      localDataSource: mockNumberTriviaLocalDataSource,
      networkInfos: mockNetworkInfos,
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
      // Act
      await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
      // Assert
      verify(() => mockNetworkInfos.checkConnection()).called(1);
    });

    group('device online', () {
      setUp(
        () => when(() => mockNetworkInfos.checkConnection())
            .thenAnswer((_) async => true),
      );
      test("""should return NumberTrivia from remote data source when
          a remote data number trivia call is successful
          and cache and number trivia""", () async {
        // Arrange

        when(() => mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(
            tNumber)).thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockNumberTriviaLocalDataSource
            .cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => {});
        // Act
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
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
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // Assert

        expect(result, equals(Left(ServerFailure())));
        verify(
          () {
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber);
          },
        ).called(1);
        verifyNoMoreInteractions(mockNumberTriviaLocalDataSource);
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
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // Assert

        expect(result, equals(Right(tNumberTrivia)));
        verify(
          () {
            mockNumberTriviaLocalDataSource.getCachedNumberTrivia();
          },
        ).called(1);

        verifyNoMoreInteractions(mockNumberTriviaLocalDataSource);
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
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
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // Assert

        verify(
          () {
            mockNumberTriviaLocalDataSource.getCachedNumberTrivia();
          },
        ).called(1);
        verifyNoMoreInteractions(mockNumberTriviaLocalDataSource);
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
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
      // Act
      await numberTriviaRepositoryImpl.getRandomNumberTrivia();
      // Assert
      verify(() => mockNetworkInfos.checkConnection()).called(1);
    });

    group('device online', () {
      setUp(
        () => when(() => mockNetworkInfos.checkConnection())
            .thenAnswer((_) async => true),
      );
      test("""should return NumberTrivia from remote data source when
          a remote data number trivia call is successful
          and cache and number trivia""", () async {
        // Arrange

        when(() => mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockNumberTriviaLocalDataSource
            .cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => {});
        // Act
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
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
      });

      test(
          'should return a server failure when a remote data number trivia call is unsuccessful',
          () async {
        // Arrange

        when(
          () => mockNumberTriviaRemoteDataSource.getRandomNumberTrivia(),
        ).thenThrow(ServerException());
        // Act
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        // Assert

        expect(result, equals(Left(ServerFailure())));
        verify(
          () {
            mockNumberTriviaRemoteDataSource.getRandomNumberTrivia();
          },
        ).called(1);
        verifyZeroInteractions(mockNumberTriviaLocalDataSource);
        verifyNoMoreInteractions(mockNumberTriviaRemoteDataSource);
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
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        // Assert

        expect(result, equals(Right(tNumberTrivia)));
        verify(
          () {
            mockNumberTriviaLocalDataSource.getCachedNumberTrivia();
          },
        ).called(1);

        verifyNoMoreInteractions(mockNumberTriviaLocalDataSource);
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
      });

      test(
          'should return a NoCachedDataFailure when a there is no cahed data present',
          () async {
        // Arrange

        when(
          () => mockNumberTriviaLocalDataSource.getCachedNumberTrivia(),
        ).thenThrow(NoCachedNumberTriviaException());
        // Act
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        // Assert

        verify(
          () {
            mockNumberTriviaLocalDataSource.getCachedNumberTrivia();
          },
        ).called(1);
        verifyNoMoreInteractions(mockNumberTriviaLocalDataSource);
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        expect(result, equals(Left(NoCachedDataFailure())));
      });
    });
  });
}
