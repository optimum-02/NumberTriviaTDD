import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/presentation/locale_bloc/locale_bloc.dart';

void main() {
  late LocaleBloc localeBloc;

  setUp(() {
    localeBloc = LocaleBloc();
  });
  test('should emit locale state', () async {
    // Arrange
    const tLocal = Locale("fr");
    // Act
    localeBloc.add(LocaleChanged(tLocal));

    // Assert
    await expectLater(localeBloc.stream, emits(const LocaleState(tLocal)));
  });
}
