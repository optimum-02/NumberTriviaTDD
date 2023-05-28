import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:number_trivia/core/platform/date_utils.dart';
import 'package:number_trivia/core/platform/language_infos.dart';
import 'package:number_trivia/features/number_trivia/presentation/locale_bloc/locale_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/platform/network_infos.dart';
import 'core/utils/input_converter.dart';
import 'features/number_trivia/data/datasources/local_datasource.dart';
import 'features/number_trivia/data/datasources/remote_datasource.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/use_cases/get_date_trivia.dart';
import 'features/number_trivia/domain/use_cases/get_math_trivia.dart';
import 'features/number_trivia/domain/use_cases/get_random_date_trivia.dart';
import 'features/number_trivia/domain/use_cases/get_random_math_trivia.dart';
import 'features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/number_trivia/date_trivia_bloc/date_trivia_bloc.dart';
import 'features/number_trivia/presentation/number_trivia/math_trivia_bloc/math_trivia_bloc.dart';
import 'features/number_trivia/presentation/number_trivia/number_trivia_bloc/number_trivia_bloc.dart';

final getBloc = GetIt.instance;
final getRepo = GetIt.instance;
final getCore = GetIt.instance;
final getPub = GetIt.instance;
Future<void> init() async {
  await initPub();
  initBloc();
  initRepo();
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
  getBloc.registerFactory(
    () => MathTriviaBloc(
      getMathTrivia: getRepo(),
      getRandomMathTrivia: getRepo(),
      inputConverter: getCore(),
    ),
  );
  getBloc.registerFactory(
    () => DateTriviaBloc(
      getDateTrivia: getRepo(),
      getRandomDateTrivia: getRepo(),
      inputConverter: getCore(),
    ),
  );
  getBloc.registerFactory(
    () => LocaleBloc(),
  );
}

initCore() {
  getCore.registerLazySingleton(() => InputConverter());
  getCore.registerLazySingleton<NetworkInfos>(() => NetworkInfosImpl(getPub()));
  getCore.registerLazySingleton<Translation>(
      () => GoogleTranslationImp(http: getPub()));
  getCore
      .registerLazySingleton<IAUtils>(() => GptDateUtils(httpClient: getPub()));
}

initRepo() {
  getRepo.registerLazySingleton(() => GetConcreteNumberTrivia(getRepo()));
  getRepo.registerLazySingleton(() => GetRandomNumberTrivia(getRepo()));
  getRepo.registerLazySingleton(() => GetMathTrivia(getRepo()));
  getRepo.registerLazySingleton(() => GetRandomMathTrivia(getRepo()));
  getRepo.registerLazySingleton(() => GetDateTrivia(getRepo()));
  getRepo.registerLazySingleton(() => GetRandomDateTrivia(getRepo()));

  getRepo.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
        remoteDataSource: getRepo(),
        localDataSource: getRepo(),
        networkInfos: getRepo(),
        translation: getBloc()),
  );

  getRepo.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(getPub(), getCore()),
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
