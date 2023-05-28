part of "../pages/number_trivia_page.dart";

class DateTriviaText extends StatelessWidget {
  const DateTriviaText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateTriviaBloc, DateTriviaState>(
      builder: (context, state) {
        return Expanded(
          child: Builder(builder: (context) {
            if (state is DateTriviaLoading) {
              return const Center(
                child: SizedBox(
                  height: 48,
                  width: 48,
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            } else if (state is DateTriviaInitial) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    TKeys.welcomeText.tr(context),
                    style: textStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).iconTheme.color),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    TKeys.initialInstructionTextForDateTrivia.tr(context),
                    textAlign: TextAlign.center,
                    style: textStyle.copyWith(
                        fontSize: 16, color: Theme.of(context).iconTheme.color),
                  ),
                ],
              );
            } else {
              final DateTriviaLoaded st = state as DateTriviaLoaded;
              return st.numberTriviaOrFailure.fold(
                (failure) {
                  if (failure is ServerFailure) {
                    return ErrorText(
                      errorText: TKeys.serverFailureText.tr(context),
                    );
                  } else if (failure is InvalidInputFailure) {
                    return ErrorText(
                      errorText: TKeys.invalidInputFailure.tr(context),
                    );
                  } else if (failure is TransalationFailedFailure) {
                    return ErrorText(
                      errorText:
                          TKeys.transalationFailedFailureText.tr(context),
                    );
                  } else {
                    return ErrorText(
                      errorText: TKeys.noCachedDataFailureText.tr(context),
                    );
                  }
                },
                (numberTrivia) {
                  return TriviaDisplay(
                    numberTrivia: numberTrivia,
                    dateTrivia: true,
                    locale: context.locale().languageCode,
                  );
                },
              );
            }
          }),
        );
      },
    );
  }
}
