import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../model/items_model.dart';
import '../../utils/colors.dart';
import 'components.dart';

class IntoScreen extends StatefulWidget {
  const IntoScreen({Key? key}) : super(key: key);

  @override
  State<IntoScreen> createState() => _HomePageState();
}

class _HomePageState extends State<IntoScreen> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Widget animationDo(
    int index,
    int delay,
    Widget child,
  ) {
    if (index == 1) {
      return FadeInDown(
        delay: Duration(milliseconds: delay),
        child: child,
      );
    }
    return FadeInUp(
      delay: Duration(milliseconds: delay),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: pageController,
                itemCount: listOfItems.length,
                onPageChanged: (newIndex) {
                  setState(() {
                    currentIndex = newIndex;
                  });
                },
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      SizedBox(
                        width: size.width,
                        height: size.height,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(15, 40, 15, 10),
                              width: size.width,
                              height: size.height / 2.5,
                              child: animationDo(
                                index,
                                100,
                                Image.asset(listOfItems[index].img),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: animationDo(
                                index,
                                100,
                                Text(
                                  listOfItems[index].title,
                                  textAlign: TextAlign.center,
                                  style: textTheme.displayLarge,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset(
                            'assets/logo_0.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmoothPageIndicator(
                    controller: pageController,
                    count: listOfItems.length,
                    effect: const ExpandingDotsEffect(
                      spacing: 6.0,
                      radius: 10.0,
                      dotWidth: 10.0,
                      dotHeight: 10.0,
                      expansionFactor: 3.8,
                      dotColor: Colors.grey,
                      activeDotColor: MyColors.btnColor,
                    ),
                    onDotClicked: (newIndex) {
                      setState(() {
                        currentIndex = newIndex;
                        pageController.animateToPage(
                          newIndex,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      });
                    },
                  ),
                  currentIndex == 3
                      ? GetStartBtn(size: size, textTheme: textTheme)
                      : SkipBtn(
                          size: size,
                          textTheme: textTheme,
                          onTap: () {
                            setState(() {
                              pageController.animateToPage(
                                3,
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.fastOutSlowIn,
                              );
                            });
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
