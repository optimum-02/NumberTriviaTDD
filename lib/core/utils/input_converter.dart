import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

class InputConverter {
  Either<Failure, int> toUnsignedInteger(String str) {
    try {
      print(str);
      // if (str.isEmpty) throw const FormatException("Empty string passed");
      final integer = int.parse(str);
      print(integer);
      if (integer.isNegative) {
        throw const FormatException("The number can not be negative");
      }

      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}
