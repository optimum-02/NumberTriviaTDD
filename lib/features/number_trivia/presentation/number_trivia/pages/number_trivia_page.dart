import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../injection_dependency.dart';
import '../bloc/number_trivia_bloc.dart';

class NumbertriviaPage extends StatelessWidget {
  const NumbertriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade800,
          elevation: 8,
          title: const Text(
            "Number Trivia",
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: const NumberTriviaBody());
  }
}

class NumberTriviaBody extends StatelessWidget {
  const NumberTriviaBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getBloc<NumberTriviaBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
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

class NumberTriviaText extends StatelessWidget {
  const NumberTriviaText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
      builder: (context, state) {
        return Expanded(
          child: Builder(builder: (context) {
            if (state is NumberTriviaLoading) {
              return const Center(
                child: SizedBox(
                  height: 48,
                  width: 48,
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            } else if (state is NumberTriviaInitial) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome ! 😍",
                    style: textStyle.copyWith(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    "Enter or get random number and his meaning 🤗",
                    textAlign: TextAlign.center,
                    style: textStyle.copyWith(fontSize: 16),
                  ),
                ],
              );
            } else {
              final NumberTriviaLoaded st = state as NumberTriviaLoaded;
              return st.numberTriviaOrFailure.fold(
                (failure) {
                  if (failure is ServerFailure) {
                    return Center(
                      child: Text(
                        '😱 Server failure occured',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.orange.shade400,
                          height: 1.5,
                        ),
                      ),
                    );
                  } else if (failure is InvalidInputFailure) {
                    return Center(
                        child: Text(
                      '😱 Invalid input number. Please enter a correct number',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.orange.shade400,
                        height: 1.5,
                      ),
                    ));
                  } else {
                    return Center(
                        child: Text(
                      '😱 No internet and no cached data found',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.orange.shade400,
                        height: 1.5,
                      ),
                    ));
                  }
                },
                (numberTrivia) {
                  return TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween(begin: 0.2, end: 1.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FixedSize(),
                        Text(
                          '${numberTrivia.number}',
                          textAlign: TextAlign.center,
                          style: textStyle.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const FixedSize(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            numberTrivia.text,
                            textAlign: TextAlign.center,
                            style: textStyle.copyWith(
                                fontSize: 16,
                                height: 1.2,
                                overflow: TextOverflow.fade),
                            //
                          ),
                        ),
                      ],
                    ),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value.toDouble(),
                        child: child,
                      );
                    },
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
            context.read<NumberTriviaBloc>().add(
                  GetConcreteNumberTriviaEvent(number.text),
                );
            number.clear();
          },
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: textStyle.copyWith(fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Enter a number',
            contentPadding: const EdgeInsets.all(2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
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
                    style:
                        ElevatedButton.styleFrom(padding: EdgeInsets.all(16)),
                    onPressed: state is NumberTriviaLoading
                        ? null
                        : () {
                            context.read<NumberTriviaBloc>().add(
                                  GetConcreteNumberTriviaEvent(number.text),
                                );
                            setState(() {
                              number.clear();
                            });
                          },
                    child: const Text(
                      'Search',
                      style: textStyle,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: OutlinedButton(
                    style:
                        OutlinedButton.styleFrom(padding: EdgeInsets.all(16)),
                    onPressed: state is NumberTriviaLoading
                        ? null
                        : () {
                            context.read<NumberTriviaBloc>().add(
                                  const GetRandomNumberTriviaEvent(),
                                );
                            setState(() {
                              number.clear();
                            });
                          },
                    child: const Text(
                      'Get Random',
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

class FixedSize extends StatelessWidget {
  const FixedSize({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 8);
  }
}

const textStyle = TextStyle(
  fontSize: 15,
);
