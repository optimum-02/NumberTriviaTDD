import 'dart:convert';

import 'package:http/http.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
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
