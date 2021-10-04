import 'package:flutter/material.dart';

class QuizMenu extends StatefulWidget {
  QuizMenu({Key? key}) : super(key: key);

  @override
  _QuizMenuState createState() => _QuizMenuState();
}

class _QuizMenuState extends State<QuizMenu> with TickerProviderStateMixin {
  late AnimationController firstAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  late Animation<double> firstAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(firstAnimationController);
  late AnimationController secondAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  late Animation<double> secondAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(secondAnimationController);

  late List<String> menu = ["1", "2", "3", "4", "5"];
  late List<String> firstSubmenu = [];
  late List<String> secondMenu = [];
  final double quizTypeWidthPercentage = 0.45;
  final double quizTypeMaxHeightPercentage = 0.275;
  final double quizTypeMinHeightPercentage = 0.175;
  final double quizTypeTopMargin = 0.35;
  final double quizTypeHorizontalMargin = 12.5;
  final double quizTypeBetweenVerticalSpacing = 0.015;
  final List<int> maxHeightQuizTypeIndexes = [0, 3, 4, 7, 8];

  late int currentDisplayMenu = 1;

  double _getTopMarginForQuizTypeContainer(int quizTypeIndex) {
    double topMarginPercentage = quizTypeTopMargin;
    int baseCondition = quizTypeIndex % 2 == 0 ? 0 : 1;
    for (int i = quizTypeIndex; i > baseCondition; i = i - 2) {
      //
      double topQuizTypeHeight = maxHeightQuizTypeIndexes.contains(i - 2) ? quizTypeMaxHeightPercentage : quizTypeMinHeightPercentage;

      topMarginPercentage = topMarginPercentage + quizTypeBetweenVerticalSpacing + topQuizTypeHeight;
    }
    return topMarginPercentage;
  }

  Widget _buildQuizType(int quizTypeIndex) {
    double topMarginPercentage = quizTypeTopMargin;

    if (quizTypeIndex - 2 < 0) {
      topMarginPercentage = quizTypeTopMargin;
    } else {
      topMarginPercentage = _getTopMarginForQuizTypeContainer(quizTypeIndex);
    }

    bool isLeft = quizTypeIndex % 2 == 0;

    if (quizTypeIndex < 4) {
      return AnimatedBuilder(
        builder: (context, child) {
          return Positioned(
            top: MediaQuery.of(context).size.height * topMarginPercentage,
            left: isLeft ? quizTypeHorizontalMargin : null,
            right: isLeft ? null : quizTypeHorizontalMargin,
            child: SlideTransition(
              position: firstAnimation.drive<Offset>(Tween<Offset>(begin: Offset.zero, end: Offset(isLeft ? -1.0 : 1.0, 0))),
              child: FadeTransition(
                opacity: firstAnimation.drive<double>(Tween<double>(begin: 1.0, end: 0.0)),
                child: child!,
              ),
            ),
          );
        },
        animation: firstAnimationController,
        child: _buildQuizTypeContainer(quizTypeWidthPercentage, maxHeightQuizTypeIndexes.contains(quizTypeIndex) ? quizTypeMaxHeightPercentage : quizTypeMinHeightPercentage, quizTypeIndex),
      );
    } else if (quizTypeIndex < 8) {
      return AnimatedBuilder(
        builder: (context, child) {
          double endMarginPercentage = quizTypeTopMargin;
          //change static number to length of menu
          if (quizTypeIndex == 6 || quizTypeIndex == 7) {
            double previousTopQuizTypeHeight = maxHeightQuizTypeIndexes.contains(quizTypeIndex - 2) ? quizTypeMaxHeightPercentage : quizTypeMinHeightPercentage;
            endMarginPercentage = quizTypeTopMargin + quizTypeBetweenVerticalSpacing + previousTopQuizTypeHeight;
          }

          double topPositionPercentage = firstAnimation.drive<double>(Tween(begin: topMarginPercentage, end: endMarginPercentage)).value;

          return Positioned(
            top: MediaQuery.of(context).size.height * topPositionPercentage,
            left: isLeft ? quizTypeHorizontalMargin : null,
            right: isLeft ? null : quizTypeHorizontalMargin,
            child: SlideTransition(
              position: secondAnimation.drive<Offset>(Tween<Offset>(begin: Offset.zero, end: Offset(isLeft ? -1.0 : 1.0, 0))),
              child: FadeTransition(
                opacity: secondAnimation.drive<double>(Tween<double>(begin: 1.0, end: 0.0)),
                child: child!,
              ),
            ),
          );
        },
        animation: firstAnimationController,
        child: _buildQuizTypeContainer(quizTypeWidthPercentage, maxHeightQuizTypeIndexes.contains(quizTypeIndex) ? quizTypeMaxHeightPercentage : quizTypeMinHeightPercentage, quizTypeIndex),
      );
    } else {
      return AnimatedBuilder(
        animation: firstAnimationController,
        builder: (context, child) {
          return AnimatedBuilder(
            builder: (context, child) {
              double firstEndMarginPercentage = _getTopMarginForQuizTypeContainer(quizTypeIndex - 4);
              double topPositionPercentage = 0.0;

              if (firstAnimationController.isAnimating) {
                topPositionPercentage = firstAnimation.drive<double>(Tween(begin: topMarginPercentage, end: firstEndMarginPercentage)).value;
              } else {
                topPositionPercentage = secondAnimation.drive<double>(Tween(begin: firstEndMarginPercentage, end: quizTypeTopMargin)).value;
              }
              return Positioned(
                top: MediaQuery.of(context).size.height * topPositionPercentage,
                left: isLeft ? quizTypeHorizontalMargin : null,
                right: isLeft ? null : quizTypeHorizontalMargin,
                child: child!,
              );
            },
            animation: secondAnimationController,
            child: _buildQuizTypeContainer(quizTypeWidthPercentage, maxHeightQuizTypeIndexes.contains(quizTypeIndex) ? quizTypeMaxHeightPercentage : quizTypeMinHeightPercentage, quizTypeIndex),
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
    for (int i = 0; i < menu.length; i++) {
      children.add(_buildQuizType(i));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        if (firstAnimationController.isCompleted) {
          firstAnimationController.reverse();
        } else {
          firstAnimationController.forward();
        }
      }),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                if (secondAnimationController.isCompleted) {
                  secondAnimationController.reverse();
                } else {
                  secondAnimationController.forward();
                }
              },
              icon: Icon(Icons.play_arrow))
        ],
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [..._buildQuizTypes()],
      ),
    );
  }
}
