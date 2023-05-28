import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:number_trivia/core/utils/input_converter.dart';

import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/locale_bloc/locale_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/localization/localization_export.dart';
import '../../../../../injection_dependency.dart';
import '../../theme_bloc/theme_bloc.dart';
import '../date_trivia_bloc/date_trivia_bloc.dart';
import '../math_trivia_bloc/math_trivia_bloc.dart';
import '../number_trivia_bloc/number_trivia_bloc.dart';

part '../widget/number_trivia_control.dart';
part '../widget/page_title.dart';
part '../widget/number_trivia_display.dart';
part '../widget/widget.dart';
part '../widget/page_view_body.dart';
part '../widget/math_trivia_control.dart';
part '../widget/date_trivia_control.dart';
part '../widget/date_trivia_display.dart';
part '../widget/math_trivia_display.dart';

class NumbertriviaPage extends StatelessWidget {
  const NumbertriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    context
        .read<LocaleBloc>()
        .add(LocaleChanged(Localizations.localeOf(context)));
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: const NumberTriviaBody(),
    );
  }
}

class NumberTriviaBody extends StatelessWidget {
  const NumberTriviaBody({super.key});

  @override
  Widget build(BuildContext context) {
    final current = Localizations.localeOf(context).languageCode;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getBloc<DateTriviaBloc>()
            ..add(GetDateTriviaEvent(
                DateTime.now(),
                context.read<LocaleBloc>().state.locale?.languageCode ??
                    current)),
        ),
        BlocProvider(
          lazy: true,
          create: (context) {
            return getBloc<NumberTriviaBloc>();
          },
        ),
        BlocProvider(
          lazy: true,
          create: (context) => getBloc<MathTriviaBloc>(),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            TitleWidget(),
            PageViewBody(),
          ],
        ),
      ),
    );
  }
}
