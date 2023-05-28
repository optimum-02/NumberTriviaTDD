part of "../pages/number_trivia_page.dart";

class MathTriviaControls extends StatefulWidget {
  const MathTriviaControls({super.key});

  @override
  State<MathTriviaControls> createState() => _MathTriviaControlsState();
}

class _MathTriviaControlsState extends State<MathTriviaControls> {
  final number = TextEditingController();

  getConcreteMathTriviaPressed(MathTriviaState state) {
    if (state is MathTriviaLoading) {
      return null;
    } else {
      context.read<MathTriviaBloc>().add(
            GetMathTriviaEvent(number.text,
                context.read<LocaleBloc>().state.locale!.languageCode),
          );
      setState(() {
        number.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: number,
          onChanged: (value) {
            setState(() {});
          },
          onFieldSubmitted: (value) {
            // context.read<NumberTriviaBloc>().add(
            //       GetConcreteNumberTriviaEvent(number.text),
            //     );
            // umber.clear();
          },
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: textStyle.copyWith(fontSize: 16),
          decoration: InputDecoration(
            hintText: TKeys.hintEnterNumber.tr(context),
            contentPadding: const EdgeInsets.all(2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 24),
        BlocBuilder<MathTriviaBloc, MathTriviaState>(
          builder: (context, state) {
            return Row(
              children: [
                Expanded(
                  child: Tooltip(
                    message: TKeys.concreteButtonTooltip.tr(context),
                    child: ElevatedButton(
                      onPressed: number.text.isEmpty
                          ? null
                          : () {
                              getConcreteMathTriviaPressed(state);
                              setState(() {});
                            },
                      child: Text(
                        TKeys.buttonSearchTriviaText.tr(context),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Tooltip(
                    message: TKeys.randomButtonTooltip.tr(context),
                    child: OutlinedButton(
                      onPressed: state is MathTriviaLoading
                          ? null
                          : () {
                              context.read<MathTriviaBloc>().add(
                                    GetRandomMathTriviaEvent(context
                                        .read<LocaleBloc>()
                                        .state
                                        .locale!
                                        .languageCode),
                                  );
                              setState(() {
                                number.clear();
                              });
                            },
                      child: Text(
                        TKeys.buttonRandomTriviaText.tr(context),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
