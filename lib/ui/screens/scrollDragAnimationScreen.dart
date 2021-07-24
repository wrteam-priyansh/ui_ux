import 'package:flutter/material.dart';

class ScrollDragAnimationScreen extends StatefulWidget {
  ScrollDragAnimationScreen({Key? key}) : super(key: key);

  @override
  _ScrollDragAnimationScreenState createState() => _ScrollDragAnimationScreenState();
}

class _ScrollDragAnimationScreenState extends State<ScrollDragAnimationScreen> with TickerProviderStateMixin {
  final double quizTypeWidthPercentage = 0.45;
  final double quizTypeMaxHeightPercentage = 0.3;
  final double quizTypeMinHeightPercentage = 0.2;
  final double quizTypeTopMargin = 0.35;
  final List<int> maxHeightQuizTypeIndexes = [0, 3, 4, 7];
  final double quizTypeHorizontalMargin = 12.5;
  final double quizTypeBetweenVerticalSpacing = 0.015;

  late AnimationController animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  late AnimationController bottomQuizTypeOpacityAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300))..forward();

  late Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
  late Animation<double> bottomQuizTypeOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: bottomQuizTypeOpacityAnimationController, curve: Curves.easeInOut));
  late List<String> menu = [
    "QuizType1",
    "QuizType2",
    "QuizType3",
    "QuizType4",
    "QuizType5",
    "QuizType6",
    "QuizType7",
    "QuizType8",
  ];

  void startAnimation() async {
    await animationController.forward();

    animationController.dispose();
    bottomQuizTypeOpacityAnimationController.dispose();
    setState(() {
      menu = menu.sublist(4, 8)..addAll(menu.sublist(0, 4));
      animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
      animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
      bottomQuizTypeOpacityAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
      bottomQuizTypeOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: bottomQuizTypeOpacityAnimationController, curve: Curves.easeInOut));
    });
    bottomQuizTypeOpacityAnimationController.forward();
  }

  @override
  void dispose() {
    bottomQuizTypeOpacityAnimationController.dispose();
    animationController.dispose();
    super.dispose();
  }

  Widget _buildQuizType(int quizTypeIndex) {
    double topMarginPercentage = quizTypeTopMargin;

    if (quizTypeIndex - 2 < 0) {
      topMarginPercentage = quizTypeTopMargin;
    } else {
      int baseCondition = quizTypeIndex % 2 == 0 ? 0 : 1;
      for (int i = quizTypeIndex; i > baseCondition; i = i - 2) {
        //
        double topQuizTypeHeight = maxHeightQuizTypeIndexes.contains(i - 2) ? quizTypeMaxHeightPercentage : quizTypeMinHeightPercentage;

        topMarginPercentage = topMarginPercentage + quizTypeBetweenVerticalSpacing + topQuizTypeHeight;
      }
    }

    if (quizTypeIndex % 2 == 0) {
      //if questionType index is less than 4
      if (quizTypeIndex <= 3) {
        //add animation for horizontal slide and opacity
        return AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Positioned(
                child: Opacity(opacity: 1.0 - (1.0 * animation.value), child: _buildQuizTypeContainer(quizTypeWidthPercentage, maxHeightQuizTypeIndexes.contains(quizTypeIndex) ? quizTypeMaxHeightPercentage : quizTypeMinHeightPercentage, quizTypeIndex)),
                top: MediaQuery.of(context).size.height * topMarginPercentage,
                left: quizTypeHorizontalMargin - MediaQuery.of(context).size.width * quizTypeWidthPercentage * animation.value - quizTypeHorizontalMargin * animation.value,
              );
            });
      }
      return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          double end = quizTypeTopMargin;
          //change static number to length of menu
          if (quizTypeIndex == (menu.length - 1) || quizTypeIndex == (menu.length - 2)) {
            double previousTopQuizTypeHeight = maxHeightQuizTypeIndexes.contains(quizTypeIndex - 2) ? quizTypeMaxHeightPercentage : quizTypeMinHeightPercentage;
            end = quizTypeTopMargin + quizTypeBetweenVerticalSpacing + previousTopQuizTypeHeight;
          }
          double topMargin = animation.drive(Tween(begin: topMarginPercentage, end: end)).value;

          return Positioned(
            child: GestureDetector(
              onVerticalDragUpdate: (dragUpdateDetails) {
                double dragged = dragUpdateDetails.primaryDelta! / MediaQuery.of(context).size.height;

                animationController.value = animationController.value - 5.0 * dragged;
              },
              onVerticalDragEnd: (dragEndDetails) async {
                startAnimation();
              },
              child: FadeTransition(
                  opacity: bottomQuizTypeOpacityAnimation, child: _buildQuizTypeContainer(quizTypeWidthPercentage, maxHeightQuizTypeIndexes.contains(quizTypeIndex) ? quizTypeMaxHeightPercentage : quizTypeMinHeightPercentage, quizTypeIndex)),
            ),
            top: MediaQuery.of(context).size.height * topMargin,
            left: quizTypeHorizontalMargin,
          );
        },
      );
    } else {
      //for odd index
      if (quizTypeIndex <= 3) {
        //add animation for horizontal slide and opacity
        return AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Positioned(
                child: Opacity(opacity: 1.0 - (1.0 * animation.value), child: _buildQuizTypeContainer(quizTypeWidthPercentage, maxHeightQuizTypeIndexes.contains(quizTypeIndex) ? quizTypeMaxHeightPercentage : quizTypeMinHeightPercentage, quizTypeIndex)),
                top: MediaQuery.of(context).size.height * topMarginPercentage,
                right: quizTypeHorizontalMargin - MediaQuery.of(context).size.width * quizTypeWidthPercentage * animation.value - quizTypeHorizontalMargin * animation.value,
              );
            });
      }

      return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          double end = quizTypeTopMargin;
          //change static number to length of menu
          if (quizTypeIndex == (menu.length - 1) || quizTypeIndex == (menu.length - 2)) {
            double previousTopQuizTypeHeight = maxHeightQuizTypeIndexes.contains(quizTypeIndex - 2) ? quizTypeMaxHeightPercentage : quizTypeMinHeightPercentage;
            end = quizTypeTopMargin + quizTypeBetweenVerticalSpacing + previousTopQuizTypeHeight;
          }

          double topMargin = animation.drive(Tween(begin: topMarginPercentage, end: end)).value;

          return Positioned(
            child: GestureDetector(
                onVerticalDragUpdate: (dragUpdateDetails) {
                  double dragged = dragUpdateDetails.primaryDelta! / MediaQuery.of(context).size.height;

                  animationController.value = animationController.value - 5.0 * dragged;
                },
                onVerticalDragEnd: (dragEndDetails) async {
                  startAnimation();
                },
                child: FadeTransition(
                    opacity: bottomQuizTypeOpacityAnimation, child: _buildQuizTypeContainer(quizTypeWidthPercentage, maxHeightQuizTypeIndexes.contains(quizTypeIndex) ? quizTypeMaxHeightPercentage : quizTypeMinHeightPercentage, quizTypeIndex))),
            top: MediaQuery.of(context).size.height * topMargin,
            right: quizTypeHorizontalMargin,
          );
        },
      );
    }
  }

  Widget _buildQuizTypeContainer(double widthPercentage, double heightPercentage, int quizTypeIndex) {
    return Container(
      child: Center(child: Text("${menu[quizTypeIndex]}")),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Theme.of(context).primaryColor,
      ),
      width: MediaQuery.of(context).size.width * 0.45,
      height: MediaQuery.of(context).size.height * heightPercentage,
    );
  }

  List<Widget> _buildQuizTypes() {
    List<Widget> children = [];
    for (int i = 0; i < 8; i++) {
      Widget child = AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return _buildQuizType(i);
        },
      );
      children.add(child);
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [..._buildQuizTypes()],
      ),
    );
  }
}
