part of "../pages/number_trivia_page.dart";

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;
  const TriviaDisplay({
    Key? key,
    required this.numberTrivia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.fast),
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 800),
          tween: Tween(begin: 0.2, end: 1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FixedSize(),
              Text(
                numberTrivia.number?.toString() ?? "∞",
                textAlign: TextAlign.center,
                style: textStyle.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).iconTheme.color),
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
                      color: Theme.of(context).iconTheme.color),
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
        ),
      ),
    );
  }
}

class ErrorText extends StatelessWidget {
  final String errorText;
  const ErrorText({
    Key? key,
    required this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      errorText,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15,
        color: Colors.orange.shade400,
        height: 1.5,
      ),
    ));
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
