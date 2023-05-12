import 'package:dartz/dartz.dart';
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
  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfos,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return getRandomOrConcreteNumberTrivia(
        () => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return getRandomOrConcreteNumberTrivia(
        () => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> getRandomOrConcreteNumberTrivia(
      Future<NumberTriviaModel> Function() randomOrRandomNumberTrivia) async {
    if (await networkInfos.checkConnection()) {
      try {
        final result = await randomOrRandomNumberTrivia();

        await localDataSource.cacheNumberTrivia(result);

        return Right(result);
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
