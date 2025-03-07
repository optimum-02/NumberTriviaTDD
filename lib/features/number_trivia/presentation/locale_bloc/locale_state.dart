// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'locale_bloc.dart';

@immutable
class LocaleState extends Equatable {
  final Locale? locale;

  const LocaleState(this.locale);

  @override
  List<Object?> get props => [locale];
}
