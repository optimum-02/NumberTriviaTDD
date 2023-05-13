part of 'locale_bloc.dart';

@immutable
abstract class LocaleEvent {}

class LocaleChanged extends LocaleEvent {
  final Locale locale;
  LocaleChanged(this.locale);
}
