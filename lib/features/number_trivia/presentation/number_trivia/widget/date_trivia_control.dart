part of "../pages/number_trivia_page.dart";

class DateTriviaControls extends StatefulWidget {
  const DateTriviaControls({super.key});

  @override
  State<DateTriviaControls> createState() => _DateTriviaControlsState();
}

class _DateTriviaControlsState extends State<DateTriviaControls> {
  DateTime dateTime = DateTime.now();

  Future<void> pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(0),
      lastDate: DateTime(DateTime.now().year + 50),
      keyboardType: TextInputType.datetime,
      fieldHintText: "Choose date",
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: DatePickerMode.day,
    );

    if (newDate != null) {
      setState(() {
        dateTime = newDate;
      });

      context.read<DateTriviaBloc>().add(
            GetDateTriviaEvent(dateTime,
                context.read<LocaleBloc>().state.locale!.languageCode),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = Localizations.localeOf(context).languageCode;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 2000),
                tween: Tween(begin: 0.2, end: 1.0),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(.2)),
                  child: Text(
                    DateFormat(
                            "EEE dd MMM ",
                            context
                                    .read<LocaleBloc>()
                                    .state
                                    .locale
                                    ?.languageCode ??
                                current)
                        .format(dateTime),
                    textAlign: TextAlign.center,
                    style: textStyle,
                  ),
                ),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value.toDouble(),
                    child: child,
                  );
                },
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            IconButton(
                onPressed: () => pickDate(context),
                icon: const Icon(Icons.calendar_month))
          ],
        ),
        const SizedBox(height: 24),
        BlocBuilder<DateTriviaBloc, DateTriviaState>(
          builder: (context, state) {
            return Row(
              children: [
                Expanded(
                  child: Tooltip(
                    message: TKeys.concreteButtonTooltip.tr(context),
                    child: ElevatedButton(
                      onPressed: state is DateTriviaLoading
                          ? null
                          : () => context.read<DateTriviaBloc>().add(
                                GetDateTriviaEvent(
                                    dateTime,
                                    context
                                        .read<LocaleBloc>()
                                        .state
                                        .locale!
                                        .languageCode),
                              ),
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
                      onPressed: state is DateTriviaLoading
                          ? null
                          : () {
                              context.read<DateTriviaBloc>().add(
                                    GetRandomDateTriviaEvent(context
                                        .read<LocaleBloc>()
                                        .state
                                        .locale!
                                        .languageCode),
                                  );
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
