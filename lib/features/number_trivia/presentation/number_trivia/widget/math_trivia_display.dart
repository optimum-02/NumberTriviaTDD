part of "../pages/number_trivia_page.dart";

class MathTriviaText extends StatelessWidget {
  const MathTriviaText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MathTriviaBloc, MathTriviaState>(
      builder: (context, state) {
        return Expanded(
          child: Builder(builder: (context) {
            if (state is MathTriviaLoading) {
              return const Center(
                child: SizedBox(
                  height: 48,
                  width: 48,
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            } else if (state is MathTriviaInitial) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    TKeys.initialInstructionTextForMathTrivia.tr(context),
                    textAlign: TextAlign.center,
                    style: textStyle.copyWith(
                        fontSize: 16, color: Theme.of(context).iconTheme.color),
                  ),
                ],
              );
            } else {
              final MathTriviaLoaded st = state as MathTriviaLoaded;
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
                    dateTrivia: false,
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
