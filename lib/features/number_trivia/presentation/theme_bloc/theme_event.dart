part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent {}

class ThemeChanged extends ThemeEvent {
  final ThemeData theme;
  ThemeChanged(this.theme);
}
