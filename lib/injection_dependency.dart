import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/platform/network_infos.dart';
import 'core/utils/input_converter.dart';
import 'features/number_trivia/data/datasources/local_datasource.dart';
import 'features/number_trivia/data/datasources/remote_datasource.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/number_trivia/bloc/number_trivia_bloc.dart';

final getBloc = GetIt.instance;
final getRepo = GetIt.instance;
final getCore = GetIt.instance;
final getPub = GetIt.instance;
Future<void> init() async {
  await initPub();
  initRepo();
  initBloc();
  initCore();
}

initBloc() {
  getBloc.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: getRepo(),
      getRandomNumberTrivia: getRepo(),
      inputConverter: getCore(),
    ),
  );
}

initCore() {
  getCore.registerLazySingleton(() => InputConverter());
  getCore.registerLazySingleton<NetworkInfos>(() => NetworkInfosImpl(getPub()));
}

initRepo() {
  getRepo.registerLazySingleton(() => GetConcreteNumberTrivia(getRepo()));
  getRepo.registerLazySingleton(() => GetRandomNumberTrivia(getRepo()));

  getRepo.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: getRepo(),
      localDataSource: getRepo(),
      networkInfos: getRepo(),
    ),
  );

  getRepo.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(getPub()),
  );
  getRepo.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(getPub()),
  );
}

initPub() async {
  final sp = await SharedPreferences.getInstance();
  getPub.registerSingleton<SharedPreferences>(sp);
  getPub.registerLazySingleton<http.Client>(() => http.Client());
  getPub.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
}
