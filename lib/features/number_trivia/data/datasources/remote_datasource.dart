// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/platform/date_utils.dart';
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
  final IAUtils dateUtils;

  NumberTriviaRemoteDataSourceImpl(
    this.httpClient,
    this.dateUtils,
  );
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    return await _getTriviaFromUrl("http://numbersapi.com/$number");
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return await _getTriviaFromUrl(
      "http://numbersapi.com/random",
    );
  }

  @override
  Future<NumberTriviaModel> getDateTrivia(int month, int day) async {
    return await _getTriviaFromUrl("http://numbersapi.com/$month/$day/date",
        dateTrivia: true);
  }

  @override
  Future<NumberTriviaModel> getRandomDateTrivia() async {
    return await _getTriviaFromUrl("http://numbersapi.com/random/date",
        dateTrivia: true);
  }

  @override
  Future<NumberTriviaModel> getMathTrivia(int number) async {
    return await _getTriviaFromUrl("http://numbersapi.com/$number/math");
  }

  @override
  Future<NumberTriviaModel> getRandomMathTrivia() async {
    return await _getTriviaFromUrl("http://numbersapi.com/random/math");
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(String url,
      {bool dateTrivia = false}) async {
    try {
      final result = await httpClient
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      if (result.statusCode == 200) {
        final nt = NumberTriviaModel.fromJson(
            jsonDecode(result.body) as Map<String, dynamic>);
        if (dateTrivia && nt.number != null) {
          try {
            final number = await dateUtils.getDateFromSentence(nt.text);
            return NumberTriviaModel(
                number: number.millisecondsSinceEpoch, text: nt.text);
          } on Exception {
            throw ServerException();
          }
        }
        return nt;
      } else {
        throw ServerException();
      }
    } on Exception {
      throw ServerException();
    }
  }
}
