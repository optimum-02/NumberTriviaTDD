import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getCachedNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel);
}

const cachedNumberTriviaKey = "CACHED_NUMBER_TRIVIA";

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
    final json = sharedPreferences.getString(cachedNumberTriviaKey);
    if (json != null) {
      return NumberTriviaModel.fromJson(
          jsonDecode(json) as Map<String, dynamic>);
    } else {
      throw NoCachedNumberTriviaException();
    }
  }
}
