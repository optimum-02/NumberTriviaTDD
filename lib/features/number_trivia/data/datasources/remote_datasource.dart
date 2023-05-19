import 'dart:convert';

import 'package:http/http.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
  Future<NumberTriviaModel> getMathTrivia(int number);
  Future<NumberTriviaModel> getRandomMathTrivia();
  Future<NumberTriviaModel> getDateTrivia(int month, int day);
  Future<NumberTriviaModel> getRandomDateTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final Client httpClient;

  NumberTriviaRemoteDataSourceImpl(this.httpClient);
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    return await _getTriviaFromUrl("http://numbersapi.com/$number");
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return await _getTriviaFromUrl("http://numbersapi.com/random");
  }

  @override
  Future<NumberTriviaModel> getDateTrivia(int month, int day) async {
    return await _getTriviaFromUrl("http://numbersapi.com/$month/$day/date");
  }

  @override
  Future<NumberTriviaModel> getRandomDateTrivia() async {
    return await _getTriviaFromUrl("http://numbersapi.com/random/date");
  }

  @override
  Future<NumberTriviaModel> getMathTrivia(int number) async {
    return await _getTriviaFromUrl("http://numbersapi.com/$number/date");
  }

  @override
  Future<NumberTriviaModel> getRandomMathTrivia() async {
    return await _getTriviaFromUrl("http://numbersapi.com/random/math");
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    try {
      final result = await httpClient
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      if (result.statusCode == 200) {
        return NumberTriviaModel.fromJson(
            jsonDecode(result.body) as Map<String, dynamic>);
      } else {
        throw ServerException();
      }
    } on Exception {
      throw ServerException();
    }
  }
}
