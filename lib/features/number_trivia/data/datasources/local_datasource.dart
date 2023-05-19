import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getCachedNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel);
  Future<void> cacheMathTrivia(NumberTriviaModel numberTriviaModel);
  Future<void> cacheDateTrivia(NumberTriviaModel numberTriviaModel);
  Future<NumberTriviaModel> getCachedMathTrivia();
  Future<NumberTriviaModel> getCachedDateTrivia();
}

const cachedNumberTriviaKey = "CACHED_NUMBER_TRIVIA";
const cachedMathTriviaKey = "CACHED_MATH_TRIVIA";
const cachedDateTriviaKey = "CACHED_DATE_TRIVIA";

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl(this.sharedPreferences);
  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel) {
    return sharedPreferences.setString(
        cachedNumberTriviaKey, jsonEncode(numberTriviaModel.toJson()));
  }

  @override
  Future<NumberTriviaModel> getCachedNumberTrivia() async {
    return await getCachedNumberTriviaFromKey(cachedNumberTriviaKey);
  }

  @override
  Future<NumberTriviaModel> getCachedDateTrivia() async {
    return await getCachedNumberTriviaFromKey(cachedDateTriviaKey);
  }

  @override
  Future<void> cacheDateTrivia(NumberTriviaModel numberTriviaModel) {
    return sharedPreferences.setString(
        cachedDateTriviaKey, jsonEncode(numberTriviaModel.toJson()));
  }

  @override
  Future<NumberTriviaModel> getCachedMathTrivia() async {
    return await getCachedNumberTriviaFromKey(cachedMathTriviaKey);
  }

  @override
  Future<void> cacheMathTrivia(NumberTriviaModel numberTriviaModel) {
    return sharedPreferences.setString(
        cachedMathTriviaKey, jsonEncode(numberTriviaModel.toJson()));
  }

  Future<NumberTriviaModel> getCachedNumberTriviaFromKey(String key) async {
    final json = sharedPreferences.getString(key);
    if (json != null) {
      return NumberTriviaModel.fromJson(
          jsonDecode(json) as Map<String, dynamic>);
    } else {
      throw NoCachedNumberTriviaException();
    }
  }
}
