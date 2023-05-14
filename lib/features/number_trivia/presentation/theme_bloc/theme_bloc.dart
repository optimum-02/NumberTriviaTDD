import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final BuildContext context;
  ThemeBloc(this.context)
      : super(
          ThemeState(
            MediaQuery.platformBrightnessOf(context) == Brightness.dark
                ? darkTheme
                : lightTheme,
          ),
        ) {
    on<ThemeChanged>((event, emit) {
      emit(ThemeState(event.theme));
    });
  }
}
