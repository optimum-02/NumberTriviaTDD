import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(const LocaleState(null)) {
    on<LocaleChanged>((event, emit) {
      emit(LocaleState(event.locale));
    });
  }
}
