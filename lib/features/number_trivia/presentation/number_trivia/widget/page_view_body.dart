part of "../pages/number_trivia_page.dart";

class PageViewBody extends StatefulWidget {
  const PageViewBody({super.key});

  @override
  State<PageViewBody> createState() => _PageViewBodyState();
}

class _PageViewBodyState extends State<PageViewBody> {
  final PageController pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    pageController.addListener(() {
      setState(() {
        page = pageController.page?.toInt() ?? 0;
      });
    });
    super.initState();
  }

  void navigateToProprePage(int page) {
    setState(() {
      page = page;
      if (pageController.hasClients) {
        pageController.animateToPage(
          page,
          duration: const Duration(
            milliseconds: 200,
          ),
          curve: Curves.slowMiddle,
        );
      }
    });
  }

  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              physics: const BouncingScrollPhysics(),
              pageSnapping: true,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    DateTriviaText(),
                    FixedSize(),
                    DateTriviaControls(),
                    FixedSize(),
                    FixedSize()
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    NumberTriviaText(),
                    FixedSize(),
                    TriviaControls(),
                    FixedSize(),
                    FixedSize()
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    MathTriviaText(),
                    FixedSize(),
                    MathTriviaControls(),
                    FixedSize(),
                    FixedSize()
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                // border: Border.all(color: Colors.blue),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.blue,
                      blurRadius: 1,
                      spreadRadius: 1,
                      offset: Offset(1, 0))
                ],
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).scaffoldBackgroundColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonBarIcon(
                  tooltip: TKeys.dateTriviaMenuTooltip.tr(context),
                  iconPath: "assets/date.png",
                  isActive: page == 0,
                  onClick: () => navigateToProprePage(0),
                ),
                ButtonBarIcon(
                    tooltip: TKeys.numberTriviaMenuTooltip.tr(context),
                    iconPath: "assets/number.png",
                    isActive: page == 1,
                    onClick: () => navigateToProprePage(1)),
                ButtonBarIcon(
                  tooltip: TKeys.mathTriviaMenuTooltip.tr(context),
                  iconPath: "assets/math.png",
                  isActive: page == 2,
                  onClick: () => navigateToProprePage(2),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
