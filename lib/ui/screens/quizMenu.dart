import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class QuizMenu extends StatefulWidget {
  QuizMenu({Key? key}) : super(key: key);

  @override
  _QuizMenuState createState() => _QuizMenuState();
}

class _QuizMenuState extends State<QuizMenu> with TickerProviderStateMixin {
  late AnimationController firstAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  late Animation<double> firstAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: firstAnimationController, curve: Curves.easeInOut));
  late AnimationController secondAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  late Animation<double> secondAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: secondAnimationController, curve: Curves.easeInOut));

  late List<String> menu = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];

  final double quizTypeWidthPercentage = 0.45;
  final double quizTypeMaxHeightPercentage = 0.275;
  final double quizTypeMinHeightPercentage = 0.175;
  final double quizTypeTopMargin = 0.475;
  final double quizTypeHorizontalMargin = 12.5;
  final double quizTypeBetweenVerticalSpacing = 0.015;
  final List<int> maxHeightQuizTypeIndexes = [0, 3, 4, 7, 8];
  bool? dragUP;
  int currentMenu = 1;

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

              topPositionPercentage = firstAnimation.drive<double>(Tween(begin: topMarginPercentage, end: firstEndMarginPercentage)).value;
              topPositionPercentage = topPositionPercentage - (firstEndMarginPercentage - quizTypeTopMargin) * (secondAnimation.drive<double>(Tween(begin: 0.0, end: 1.0)).value);

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

  void _navigateToQuizZone(int containerNumber) {
    //container number will be [1,2,3,4]
    if (currentMenu == 1) {
      if (containerNumber == 1) {
        print("Navigate to menu : ${menu[0]}");
      } else if (containerNumber == 2) {
        print("Navigate to menu : ${menu[1]}");
      } else if (containerNumber == 3) {
        print("Navigate to menu : ${menu[2]}");
      } else {
        print("Navigate to menu : ${menu[3]}");
      }
    } else if (currentMenu == 2) {
      //determine
      if (containerNumber == 1) {
        print("Navigate to menu : ${menu[4]}");
      } else if (containerNumber == 2) {
        if (menu.length >= 6) {
          print("Navigate to menu : ${menu[5]}");
        }
      } else if (containerNumber == 3) {
        if (menu.length >= 7) {
          print("Navigate to menu : ${menu[6]}");
        }
      } else {
        if (menu.length >= 8) {
          print("Navigate to menu : ${menu[7]}");
        }
      }
    } else {
      if (containerNumber == 1) {
        if (menu.length >= 9) {
          print("Navigate to menu : ${menu[8]}");
        }
      } else if (containerNumber == 2) {
        if (menu.length >= 10) {
          print("Navigate to menu : ${menu[9]}");
        }
      }
    }
  }

  Widget _buildTopMenuContainer() {
    return AnimatedBuilder(
      animation: firstAnimationController,
      builder: (context, child) {
        return Positioned(
          top: MediaQuery.of(context).size.height * (quizTypeTopMargin),
          child: GestureDetector(
            onTap: () {},
            onTapUp: (tapDownDetails) {
              print(tapDownDetails.globalPosition);
              double firstTapStartDx = quizTypeHorizontalMargin;
              double topTapStartDy = quizTypeTopMargin * MediaQuery.of(context).size.height;

              double secondTapStartDx = MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * (quizTypeWidthPercentage) - quizTypeHorizontalMargin;

              double thirdTapStartDy = MediaQuery.of(context).size.height * (quizTypeBetweenVerticalSpacing + quizTypeTopMargin + quizTypeMaxHeightPercentage);
              double fourthTapStartDy = MediaQuery.of(context).size.height * (quizTypeBetweenVerticalSpacing + quizTypeTopMargin + quizTypeMinHeightPercentage);

              if (tapDownDetails.globalPosition.dx >= firstTapStartDx && tapDownDetails.globalPosition.dx <= (firstTapStartDx + MediaQuery.of(context).size.width * quizTypeWidthPercentage)) {
                //
                if (tapDownDetails.globalPosition.dy >= topTapStartDy && tapDownDetails.globalPosition.dy <= (topTapStartDy + (MediaQuery.of(context).size.height * quizTypeMaxHeightPercentage))) {
                  _navigateToQuizZone(1);
                } else if (tapDownDetails.globalPosition.dy >= thirdTapStartDy && tapDownDetails.globalPosition.dy <= (thirdTapStartDy + (MediaQuery.of(context).size.height * quizTypeMinHeightPercentage))) {
                  _navigateToQuizZone(3);
                }
              } else if (tapDownDetails.globalPosition.dx >= secondTapStartDx && tapDownDetails.globalPosition.dx <= (secondTapStartDx + MediaQuery.of(context).size.width * quizTypeWidthPercentage)) {
                if (tapDownDetails.globalPosition.dy >= topTapStartDy && tapDownDetails.globalPosition.dy <= (topTapStartDy + (MediaQuery.of(context).size.height * quizTypeMinHeightPercentage))) {
                  _navigateToQuizZone(2);
                } else if (tapDownDetails.globalPosition.dy >= fourthTapStartDy && tapDownDetails.globalPosition.dy <= (fourthTapStartDy + (MediaQuery.of(context).size.height * quizTypeMaxHeightPercentage))) {
                  _navigateToQuizZone(4);
                }
              }
            },
            dragStartBehavior: DragStartBehavior.start,
            onVerticalDragUpdate: (dragUpdateDetails) {
              if (currentMenu == 1) {
                //when firstMenu is selected
                double dragged = dragUpdateDetails.primaryDelta! / MediaQuery.of(context).size.height;
                firstAnimationController.value = firstAnimationController.value - 2.50 * dragged;
              } else if (currentMenu == 2) {
                //when second menu
                if (dragUP == null) {
                  if (dragUpdateDetails.primaryDelta! < 0) {
                    if (menu.length > 8) {
                      dragUP = true;
                    }
                  } else if (dragUpdateDetails.primaryDelta! > 0) {
                    dragUP = false;
                  } else {}
                }

                //
                if (dragUP != null) {
                  if (dragUP!) {
                    double dragged = dragUpdateDetails.primaryDelta! / MediaQuery.of(context).size.height;
                    secondAnimationController.value = secondAnimationController.value - 2.50 * dragged;
                  } else {
                    double dragged = dragUpdateDetails.primaryDelta! / MediaQuery.of(context).size.height;
                    firstAnimationController.value = firstAnimationController.value - 2.50 * dragged;
                  }
                }
              } else {
                double dragged = dragUpdateDetails.primaryDelta! / MediaQuery.of(context).size.height;
                secondAnimationController.value = secondAnimationController.value - 2.50 * dragged;
              }
            },
            onVerticalDragEnd: (dragEndDetails) {
              if (currentMenu == 1) {
                if (firstAnimationController.value > 0.3) {
                  firstAnimationController.forward();
                  currentMenu = 2;
                } else {
                  firstAnimationController.reverse();
                  currentMenu = 1;
                }
              } else if (currentMenu == 2) {
                //when currentMenu is 2 then handle this condition
                if (dragUP != null) {
                  if (dragUP!) {
                    if (secondAnimationController.value > 0.3) {
                      secondAnimationController.forward();
                      currentMenu = 3;
                    } else {
                      secondAnimationController.reverse();
                      currentMenu = 2;
                    }
                  } else {
                    if (firstAnimationController.value > 0.7) {
                      firstAnimationController.forward();
                      currentMenu = 2;
                    } else {
                      firstAnimationController.reverse();
                      currentMenu = 1;
                    }
                  }
                }

                dragUP = null;
              } else {
                //
                if (secondAnimationController.value > 0.7) {
                  secondAnimationController.forward();
                  currentMenu = 3;
                } else {
                  secondAnimationController.reverse();
                  currentMenu = 2;
                }
              }
            },
            child: Container(
              color: Colors.black45,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * (1.0 - quizTypeTopMargin),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          ..._buildQuizTypes(),
          _buildTopMenuContainer(),
        ],
      ),
    );
  }
}
