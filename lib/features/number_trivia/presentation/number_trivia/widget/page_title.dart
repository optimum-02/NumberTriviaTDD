part of "../pages/number_trivia_page.dart";

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 12),
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8),
          shape: BoxShape.rectangle,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              TKeys.appTitle.tr(context),
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlocBuilder<LocaleBloc, LocaleState>(builder: (context, state) {
                  return PopupMenuButton(
                    position: PopupMenuPosition.under,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    icon: const Icon(Icons.translate_outlined),
                    initialValue: state.locale,
                    onSelected: (value) {
                      context.read<LocaleBloc>().add(LocaleChanged(value));
                    },
                    itemBuilder: (context) =>
                        AppLocalization.supportedLocales.map((locale) {
                      return PopupMenuItem(
                        value: locale,
                        child: Center(
                          child: Text(
                              "${locale.languageCode}_${locale.countryCode}"),
                        ),
                      );
                    }).toList(),
                  );
                }),
                const FixedSize(),
                BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
                  return TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.2, end: 1),
                    duration: const Duration(milliseconds: 400),
                    builder: (context, value, child) {
                      return IconButton(
                        splashColor: null,
                        padding: EdgeInsets.zero,
                        tooltip: TKeys.changeThemeTooltip.tr(context),
                        onPressed: () {
                          context.read<ThemeBloc>().add(
                                ThemeChanged(state.theme == darkTheme
                                    ? lightTheme
                                    : darkTheme),
                              );
                        },
                        icon: Opacity(
                          opacity: value,
                          child: Icon(
                            state.theme == darkTheme
                                ? Icons.sunny
                                : Icons.mode_night,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
