part of "../pages/number_trivia_page.dart";

class TriviaControls extends StatefulWidget {
  const TriviaControls({super.key});

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final number = TextEditingController();

  getConcreteNumberTriviaPressed(NumberTriviaState state) {
    context.read<NumberTriviaBloc>().add(
          GetConcreteNumberTriviaEvent(number.text,
              context.read<LocaleBloc>().state.locale!.languageCode),
        );
    setState(() {
      number.clear();
    });
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
        BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
          builder: (context, state) {
            return Row(
              children: [
                Expanded(
                  child: Tooltip(
                    message: TKeys.concreteButtonTooltip.tr(context),
                    child: ElevatedButton(
                      onPressed: number.text.isEmpty
                          ? null
                          : () => getConcreteNumberTriviaPressed(state),
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
                      onPressed: state is NumberTriviaLoading
                          ? null
                          : () {
                              context.read<NumberTriviaBloc>().add(
                                    GetRandomNumberTriviaEvent(context
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
