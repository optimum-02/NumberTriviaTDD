import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/locale_bloc/locale_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/localization/localization_export.dart';
import '../../../../../injection_dependency.dart';
import '../../theme_bloc/theme_bloc.dart';
import '../bloc/number_trivia_bloc.dart';

part '../widget/trivia_control.dart';
part '../widget/page_title.dart';
part '../widget/trivia_display.dart';
part '../widget/widget.dart';

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
    return BlocProvider(
      create: (context) {
        return getBloc<NumberTriviaBloc>();
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            TitleWidget(),
            NumberTriviaText(),
            FixedSize(),
            TriviaControls(),
            FixedSize(),
            FixedSize()
          ],
        ),
      ),
    );
  }
}
