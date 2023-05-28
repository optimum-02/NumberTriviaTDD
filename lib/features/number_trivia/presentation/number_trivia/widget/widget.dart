// ignore_for_file: public_member_api_docs, sort_constructors_first
part of "../pages/number_trivia_page.dart";

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;
  final bool dateTrivia;
  final String locale;
  const TriviaDisplay({
    Key? key,
    required this.numberTrivia,
    required this.dateTrivia,
    required this.locale,
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
              SelectableText(
                triviaTitle(),
                textAlign: TextAlign.center,
                style: textStyle.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).iconTheme.color),
              ),
              const FixedSize(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(
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

  String triviaTitle() {
    if (dateTrivia && numberTrivia.number != null) {
      final dte = DateTime.fromMillisecondsSinceEpoch(numberTrivia.number!);

      final dateFormattedEn = DateFormat("EEE MMM dd, ", "en").format(dte) +
          dte.year.abs().toString() +
          (dte.year < 0 ? " BC" : "");
      final dateFormattedFr = DateFormat("EEE dd MMM ", "fr").format(dte) +
          dte.year.abs().toString() +
          (dte.year < 0 ? " av. J-C" : "");
      // "${dte.day}-${dte.month}-${dte.year}";
      return locale == "en" ? dateFormattedEn : dateFormattedFr;
    } else {
      return numberTrivia.number?.toString() ?? "∞";
    }
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

class ButtonBarIcon extends StatelessWidget {
  final String iconPath;
  final bool isActive;
  final void Function() onClick;
  final String tooltip;
  const ButtonBarIcon(
      {super.key,
      required this.iconPath,
      required this.isActive,
      required this.onClick,
      required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Colors.blue : Colors.grey),
          child: Image.asset(
            iconPath,
            height: 24,
            width: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
