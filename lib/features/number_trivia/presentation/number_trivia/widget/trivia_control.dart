part of "../pages/number_trivia_page.dart";

class TriviaControls extends StatefulWidget {
  const TriviaControls({super.key});

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final number = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: number,
          onChanged: (value) {},
          onFieldSubmitted: (value) {
            // context.read<NumberTriviaBloc>().add(
            //       GetConcreteNumberTriviaEvent(number.text),
            //     );
            // number.clear();
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
                  child: ElevatedButton(
                    onPressed: state is NumberTriviaLoading
                        ? null
                        : () {
                            context.read<NumberTriviaBloc>().add(
                                  GetConcreteNumberTriviaEvent(
                                      number.text,
                                      context
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
                      TKeys.buttonSearchTriviaText.tr(context),
                      style: textStyle,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
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
                      style: textStyle,
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
