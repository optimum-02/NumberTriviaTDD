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
        () => remoteDataSource.getConcreteNumberTrivia(number), languageCode);
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia(
      String languageCode) async {
    return getRandomOrConcreteNumberTrivia(
        () => remoteDataSource.getRandomNumberTrivia(), languageCode);
  }

  Future<Either<Failure, NumberTrivia>> getRandomOrConcreteNumberTrivia(
      Future<NumberTriviaModel> Function() randomOrRandomNumberTrivia,
      String locale) async {
    if (await networkInfos.checkConnection()) {
      try {
        final result = await randomOrRandomNumberTrivia();

        await localDataSource.cacheNumberTrivia(result);
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
        final result = await localDataSource.getCachedNumberTrivia();

        return Right(result);
      } on NoCachedNumberTriviaException {
        return Left(NoCachedDataFailure());
      }
    }
  }
}
