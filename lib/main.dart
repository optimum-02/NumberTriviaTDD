import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/localization/localization_export.dart';
import 'features/number_trivia/presentation/locale_bloc/locale_bloc.dart';
import 'features/number_trivia/presentation/number_trivia/pages/number_trivia_page.dart';
import 'features/number_trivia/presentation/theme_bloc/theme_bloc.dart';
import 'injection_dependency.dart' as di;
import 'injection_dependency.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getBloc<LocaleBloc>(),
        ),
        BlocProvider(create: (context) {
          return ThemeBloc();
        }),
      ],
      child: const Root(),
    ),
  );
}

class Root extends StatelessWidget {
  const Root({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    setSystemThemeForFirstLauch(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: context.watch<LocaleBloc>().state.locale,
      themeAnimationDuration: const Duration(milliseconds: 50),
      themeAnimationCurve: Curves.easeIn,
      title: "Number Trivia",
      theme: context.watch<ThemeBloc>().state.theme,
      localeResolutionCallback: AppLocalization.localeResolutionCallBack,
      supportedLocales: AppLocalization.supportedLocales,
      localizationsDelegates: AppLocalization.localizationsDelegate,
      home: Builder(builder: (context) {
        return const NumbertriviaPage();
      }),
    );
  }
}

///Set the application theme to the system theme for the first lauch
setSystemThemeForFirstLauch(BuildContext context) {
  final systemTheme =
      MediaQuery.platformBrightnessOf(context) == Brightness.dark
          ? darkTheme
          : lightTheme;
  final isFirstLauch = context.read<ThemeBloc>().state.init;
  if (isFirstLauch) {
    context.read<ThemeBloc>().add(ThemeChanged(systemTheme));
  }
}
