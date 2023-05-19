import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/platform/language_infos.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/platform/network_infos.dart';
import '../datasources/local_datasource.dart';
import '../datasources/remote_datasource.dart';
import '../models/number_trivia_model.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfos networkInfos;
  final Translation translation;
  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfos,
    required this.translation,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number, String languageCode) async {
    return getRandomOrConcreteNumberTrivia(
      randomOrRandomNumberTrivia: () =>
          remoteDataSource.getConcreteNumberTrivia(number),
      cacheTrivia: (numberTriviaModel) =>
          localDataSource.cacheNumberTrivia(numberTriviaModel),
      getCachedTrivia: () => localDataSource.getCachedNumberTrivia(),
      locale: languageCode,
    );
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia(
      String languageCode) async {
    return getRandomOrConcreteNumberTrivia(
      randomOrRandomNumberTrivia: () =>
          remoteDataSource.getRandomNumberTrivia(),
      cacheTrivia: (numberTriviaModel) =>
          localDataSource.cacheNumberTrivia(numberTriviaModel),
      getCachedTrivia: () => localDataSource.getCachedNumberTrivia(),
      locale: languageCode,
    );
  }

  @override
  Future<Either<Failure, NumberTrivia>> getDateTrivia(
      int month, int day, String languageCode) {
    return getRandomOrConcreteNumberTrivia(
      randomOrRandomNumberTrivia: () =>
          remoteDataSource.getDateTrivia(month, day),
      cacheTrivia: (numberTriviaModel) =>
          localDataSource.cacheDateTrivia(numberTriviaModel),
      getCachedTrivia: () => localDataSource.getCachedDateTrivia(),
      locale: languageCode,
    );
  }

  @override
  Future<Either<Failure, NumberTrivia>> getMathTrivia(
      int number, String languageCode) {
    return getRandomOrConcreteNumberTrivia(
      randomOrRandomNumberTrivia: () => remoteDataSource.getMathTrivia(number),
      cacheTrivia: (numberTriviaModel) =>
          localDataSource.cacheMathTrivia(numberTriviaModel),
      getCachedTrivia: () => localDataSource.getCachedMathTrivia(),
      locale: languageCode,
    );
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomDateTrivia(
      String languageCode) {
    return getRandomOrConcreteNumberTrivia(
      randomOrRandomNumberTrivia: () => remoteDataSource.getRandomDateTrivia(),
      cacheTrivia: (numberTriviaModel) =>
          localDataSource.cacheDateTrivia(numberTriviaModel),
      getCachedTrivia: () => localDataSource.getCachedDateTrivia(),
      locale: languageCode,
    );
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomMathTrivia(
      String languageCode) {
    return getRandomOrConcreteNumberTrivia(
      randomOrRandomNumberTrivia: () => remoteDataSource.getRandomMathTrivia(),
      cacheTrivia: (numberTriviaModel) =>
          localDataSource.cacheMathTrivia(numberTriviaModel),
      getCachedTrivia: () => localDataSource.getCachedMathTrivia(),
      locale: languageCode,
    );
  }

  Future<Either<Failure, NumberTrivia>> getRandomOrConcreteNumberTrivia({
    required Future<NumberTriviaModel> Function() randomOrRandomNumberTrivia,
    required Future<void> Function(NumberTriviaModel numberTriviaModel)
        cacheTrivia,
    required Future<NumberTriviaModel> Function() getCachedTrivia,
    required String locale,
  }) async {
    if (await networkInfos.checkConnection()) {
      try {
        final result = await randomOrRandomNumberTrivia();

        await cacheTrivia(result);
        try {
          final translated = await translation.translate(
              text: result.text,
              targetLanguageCode: locale,
              sourceLanguageCode: "en");

          return Right(
              NumberTriviaModel(number: result.number, text: translated));
        } on TranslationFailedException {
          return Left(TransalationFailedFailure());
        }
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final result = await getCachedTrivia();

        return Right(result);
      } on NoCachedNumberTriviaException {
        return Left(NoCachedDataFailure());
      }
    }
  }
}
