import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/locale_bloc/locale_bloc.dart';

import '../errors/failures.dart';

class InputConverter {
  Either<Failure, int> toUnsignedInteger(String str) {
    try {
      // if (str.isEmpty) throw const FormatException("Empty string passed");
      final integer = int.parse(str);
      if (integer.isNegative) {
        throw const FormatException("The number can not be negative");
      }

      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

extension ContextX on BuildContext {
  Locale locale() {
    return read<LocaleBloc>().state.locale!;
  }
}
