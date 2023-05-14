import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/features/number_trivia/presentation/locale_bloc/locale_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/theme_bloc/theme_bloc.dart';

class MockContext extends Mock implements BuildContext {}

void main() {
  late MockContext mockContext;
  late ThemeBloc themeBloc;

  setUp(() {
    mockContext = MockContext();
    themeBloc = ThemeBloc(mockContext);
  });
  test('should emit a themeState', () async {
    // Arrange
    final tTheme = ThemeData();
    // Act
    themeBloc.add(ThemeChanged(tTheme));

    // Assert
    await expectLater(themeBloc.stream, emits(ThemeState(tTheme)));
  });
}
