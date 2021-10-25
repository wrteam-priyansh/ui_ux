import 'dart:math';

import 'package:flutter/material.dart';

class MeditationUx extends StatefulWidget {
  MeditationUx({Key? key}) : super(key: key);

  @override
  _MeditationUxState createState() => _MeditationUxState();
}

class _MeditationUxState extends State<MeditationUx> with TickerProviderStateMixin {
  late List<AnimationController> animationControllers = [];

  late List<Animation<double>> animations = [];

  late List<AnimationController> secondAnimationControllers = [];

  late List<Animation<double>> secondAnimations = [];

  List<int> dataList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]; //

  late AnimationController toggleCardDetailsAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 750));

  late Animation<double> toggleCardDetailsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: toggleCardDetailsAnimationController, curve: Curves.easeInOutSine));

  List<Color> color = [Colors.blue, Colors.purple, Colors.cyan, Colors.orange, Colors.pink, Colors.yellow, Colors.green, Colors.indigoAccent, Colors.blue, Colors.purple, Colors.cyan, Colors.orange];

  late double heightPercentage = 0.5;
  late double spacingBetweenTwoCards = 0.45;

  late bool openCardDetails = false;
  late int selectedCardMenuIndex = -1;

  late AnimationController cardDetailsTopMenuAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
  late Animation<double> cardDetailsTopMenuAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: cardDetailsTopMenuAnimationController, curve: Curves.easeInOutSine));

  late int currentMenu = 3; // will have two menu 1, 2 and 3

  @override
  void initState() {
    super.initState();
    initAnimations();
  }

  void initAnimations() {
    for (var i = 0; i < dataList.length; i++) {
      animationControllers.add(AnimationController(vsync: this, duration: Duration(milliseconds: 1000)));
      animations.add(Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationControllers[i], curve: Curves.easeInOutSine)));
      secondAnimationControllers.add(AnimationController(vsync: this, duration: Duration(milliseconds: 1000)));
      secondAnimations.add(Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: secondAnimationControllers[i], curve: Curves.easeInOutSine)));

      // if (i == 0) {
      //   curveAnimations.add(Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: curveAnimationController, curve: Curves.easeInOut)));
      // } else if (i == 4) {
      //   curveAnimations.add(Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: curveAnimationController, curve: Curves.easeInOut)));
      // } else if (i == 8) {
      //   curveAnimations.add(Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: curveAnimationController, curve: Curves.easeInOut)));
      // }
      //
    }
  }

  @override
  void dispose() {
    for (var i = 0; i < dataList.length; i++) {
      animationControllers[i].dispose();
      secondAnimationControllers[i].dispose();
    }
    toggleCardDetailsAnimationController.dispose();
    cardDetailsTopMenuAnimationController.dispose();
    super.dispose();
  }

  double _calculateBeginTopPositionForCard(int cardIndex) {
    double topPosition;

    //
    if (cardIndex > 7) {
      topPosition = 0.0;
      for (var i = 8; i < cardIndex; i++) {
        topPosition = topPosition + MediaQuery.of(context).size.height * (heightPercentage * spacingBetweenTwoCards);
      }
    } else {
      topPosition = -MediaQuery.of(context).size.height * heightPercentage;
      for (var i = cardIndex; i < 7; i++) {
        topPosition = topPosition - MediaQuery.of(context).size.height * (heightPercentage * spacingBetweenTwoCards);
      }
    }

    return topPosition;
  }

  double _calculateEndTopPositionForCard(int cardIndex) {
    if (cardIndex > 7) {
      return _calculateBeginTopPositionForCard(cardIndex + 5);
    }
    return _calculateBeginTopPositionForCard(cardIndex + 4);
  }

  double _calculateToggleCardEndDetails(int cardIndex) {
    if (currentMenu == 1) {}
    if (cardIndex < selectedCardMenuIndex) {
      return -(MediaQuery.of(context).size.height * heightPercentage);
    }
    if (cardIndex > selectedCardMenuIndex) {
      return MediaQuery.of(context).size.height;
    }
    return 0;
  }

  void toggleCardDetails(int cardIndex) async {
    if (openCardDetails) {
      await cardDetailsTopMenuAnimationController.reverse();
      await toggleCardDetailsAnimationController.reverse();
      setState(() {
        selectedCardMenuIndex = cardIndex;
        openCardDetails = false;
      });
    } else {
      //
      setState(() {
        selectedCardMenuIndex = cardIndex;
        openCardDetails = true;
      });
      await toggleCardDetailsAnimationController.forward();

      cardDetailsTopMenuAnimationController.forward();
    }
  }

  Widget _buildCard(int cardIndex) {
    return AnimatedBuilder(
        animation: toggleCardDetailsAnimationController,
        builder: (context, _) {
          return AnimatedBuilder(
              animation: secondAnimationControllers[cardIndex],
              builder: (context, child) {
                return AnimatedBuilder(
                  animation: animationControllers[cardIndex],
                  builder: (context, child) {
                    final double bottomRightCurveLinePercentage = toggleCardDetailsAnimation.drive(Tween<double>(begin: 1.0, end: 0.8)).value;
                    final double bottomRightCurveControlPointDy = toggleCardDetailsAnimation.drive(Tween<double>(begin: 0.5, end: 0.725)).value;
                    final double topRightCurveControlPointDy = toggleCardDetailsAnimation.drive(Tween<double>(begin: 0.275, end: 0.0)).value;
                    final double topRightCurveEndPointDx = toggleCardDetailsAnimation.drive(Tween<double>(begin: 0.8, end: 1.0)).value;
                    final double topRightCurveEndPointDy = toggleCardDetailsAnimation.drive(Tween<double>(begin: 0.2, end: 0.0)).value;
                    final double topLeftCurveEndPointDy = toggleCardDetailsAnimation.drive(Tween<double>(begin: 0.25, end: 0.0)).value;

                    double topPosition = animations[cardIndex]
                        .drive(Tween<double>(
                          begin: _calculateBeginTopPositionForCard(cardIndex),
                          end: _calculateEndTopPositionForCard(cardIndex),
                        ))
                        .value;
                    if (cardIndex < 8) {
                      if (cardIndex > 3) {
                        topPosition = topPosition + (secondAnimations[cardIndex].value * (_calculateBeginTopPositionForCard(cardIndex + 9) - topPosition));
                      } else {
                        topPosition = topPosition + (secondAnimations[cardIndex].value * (_calculateBeginTopPositionForCard(cardIndex + 8) - topPosition));
                      }
                    }
                    topPosition = topPosition + toggleCardDetailsAnimation.value * (_calculateToggleCardEndDetails(cardIndex) - topPosition);

                    return cardIndex == 4 || cardIndex == 0 || cardIndex == 8
                        ? Positioned(
                            top: topPosition,
                            child: InkWell(
                              onTap: () {
                                toggleCardDetails(cardIndex);
                              },
                              child: CustomPaint(
                                painter: CardCurve(
                                  bottomRightCurveControlPointDy: bottomRightCurveControlPointDy,
                                  color: color[cardIndex],
                                  bottomRightCurveLinePercentage: bottomRightCurveLinePercentage,
                                  topLeftCurveControlPointDx: 0,
                                  topLeftCurveControlPointDy: 0,
                                  topLeftCurveEndPointDx: 0,
                                  topLeftCurveEndPointDy: 0,
                                  topRightCurveControlPointDy: 0,
                                  topRightCurveControlPointDx: 1.0,
                                  topRightCurveEndPointDx: 1.0,
                                  topRightCurveEndPointDy: 0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(border: Border.all()),
                                  alignment: Alignment.center,
                                  child: Text("${dataList[cardIndex]}"),
                                  height: MediaQuery.of(context).size.height * heightPercentage,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                            ))
                        : Positioned(
                            top: topPosition,
                            child: InkWell(
                              onTap: () {
                                toggleCardDetails(cardIndex);
                              },
                              child: CustomPaint(
                                painter: CardCurve(
                                    bottomRightCurveControlPointDy: bottomRightCurveControlPointDy,
                                    color: color[cardIndex],
                                    bottomRightCurveLinePercentage: bottomRightCurveLinePercentage,
                                    topLeftCurveControlPointDx: 0,
                                    topLeftCurveControlPointDy: 0,
                                    topLeftCurveEndPointDx: 0,
                                    topLeftCurveEndPointDy: topLeftCurveEndPointDy,
                                    topRightCurveControlPointDy: topRightCurveControlPointDy,
                                    topRightCurveControlPointDx: 1.0,
                                    topRightCurveEndPointDx: topRightCurveEndPointDx,
                                    topRightCurveEndPointDy: topRightCurveEndPointDy),
                                child: Container(
                                  decoration: BoxDecoration(border: Border.all()),
                                  alignment: Alignment.center,
                                  child: Text("${dataList[cardIndex]}"),
                                  height: MediaQuery.of(context).size.height * heightPercentage,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                            ));
                  },
                );
              });
        });
  }

  Widget _buildBottomNavBar() {
    return AnimatedBuilder(
        animation: toggleCardDetailsAnimation,
        builder: (context, _) {
          final bottomPosition = toggleCardDetailsAnimationController
              .drive(Tween<double>(
                begin: 10,
                end: -30,
              ))
              .value;
          return Positioned(
              bottom: bottomPosition,
              left: MediaQuery.of(context).size.width * (0.1),
              child: Container(
                height: 30.0, //bottom nav bar height
                width: MediaQuery.of(context).size.width * (0.8),
                decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(15.0)),
              ));
        });
  }

  Widget _buildCardTopMenu() {
    return AnimatedBuilder(
        animation: cardDetailsTopMenuAnimationController,
        builder: (context, _) {
          final topPosition = cardDetailsTopMenuAnimation
              .drive(Tween<double>(
                begin: -30,
                end: 30,
              ))
              .value;
          return Positioned(
              top: topPosition,
              left: MediaQuery.of(context).size.width * (0.1),
              child: Opacity(
                opacity: cardDetailsTopMenuAnimation.value,
                child: Container(
                  height: 30.0, //bottom nav bar height
                  width: MediaQuery.of(context).size.width * (0.8),
                  decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(15.0)),
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ...dataList.map((e) => _buildCard(dataList.indexOf(e))).toList(),
          GestureDetector(
            onTap: () {},
            onTapUp: (tapUpDetails) {
              print("Tap up ${tapUpDetails.localPosition}");
            },
            onVerticalDragEnd: (dragEndDetails) async {
              double primaryVelocity = dragEndDetails.primaryVelocity ?? 0;
              if (primaryVelocity < 0) {
                print("Up Direction");
                //first menu start with 0 to 3
                if (currentMenu == 1) {
                  for (var i = 0; i < 8; i++) {
                    await Future.delayed(Duration(milliseconds: 100));
                    secondAnimationControllers[i].reverse().then((value) {
                      if (i == 7) {
                        setState(() {
                          currentMenu = 2;
                        });
                      }
                    });
                  }
                }
                //second menu start with 4 to 7
                else if (currentMenu == 2) {
                  for (var i = 4; i < dataList.length; i++) {
                    await Future.delayed(Duration(milliseconds: 100));
                    animationControllers[i].reverse().then((value) {
                      if (i == 7) {
                        setState(() {
                          currentMenu = 3;
                        });
                      }
                    });
                  }
                }
              } else if (primaryVelocity > 0) {
                //slide menu down side

                print("Down Direction");
                //third menu start with 8 to 11
                if (currentMenu == 3) {
                  for (var i = dataList.length - 1; i >= 0; i--) {
                    await Future.delayed(Duration(milliseconds: 100));

                    animationControllers[i].forward().then((value) {
                      if (i == 8) {
                        currentMenu = 2;
                        setState(() {});
                      }
                    });
                  }
                }

                //second menu start with 4 to 7
                else if (currentMenu == 2) {
                  for (var i = 7; i >= 0; i--) {
                    await Future.delayed(Duration(milliseconds: 100));

                    secondAnimationControllers[i].forward().then((value) {
                      if (i == 4) {
                        currentMenu = 1;
                        setState(() {});
                      }
                    });
                  }
                }
              }
            },
            child: Container(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, color: Colors.black38),
          ),
          //_buildBottomNavBar(),
          //_buildCardTopMenu(),
        ],
      ),
    );
  }
}

class CardCurve extends CustomPainter {
  final Color color;
  final double topLeftCurveControlPointDx;
  final double topLeftCurveEndPointDx;
  final double topRightCurveControlPointDx;
  final double topRightCurveEndPointDx;
  final double topRightCurveEndPointDy;
  final double topLeftCurveEndPointDy;
  final double topRightCurveControlPointDy;
  final double topLeftCurveControlPointDy;
  final double bottomRightCurveLinePercentage;
  final double bottomRightCurveControlPointDy;

  CardCurve({
    required this.color,
    required this.bottomRightCurveControlPointDy,
    required this.topLeftCurveControlPointDx,
    required this.topLeftCurveControlPointDy,
    required this.topLeftCurveEndPointDx,
    required this.topLeftCurveEndPointDy,
    required this.topRightCurveControlPointDx,
    required this.topRightCurveControlPointDy,
    required this.topRightCurveEndPointDx,
    required this.topRightCurveEndPointDy,
    required this.bottomRightCurveLinePercentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = color;
    Path path = Path();

    path.moveTo(0, size.height * (0.5));

    path.lineTo(0, size.height * (0.75));

    //bottom left curve
    //end point dx is 0.2 else 0
    path.quadraticBezierTo(0, size.height, size.width * (0.2), size.height);

    //for bottom right curve
    //path is set to (0.8,0.8) else (1.0,1.0)
    path.lineTo(size.width * bottomRightCurveLinePercentage, size.height * bottomRightCurveLinePercentage);

    //bottom right curve
    //with curve control point dy = 0.725 and flat control point dy = 0.5
    path.quadraticBezierTo(size.width, size.height * bottomRightCurveControlPointDy, size.width, size.height * (0.5));

    //topRight curve
    //for curve control point dy is 0.275 else 0
    //for curve end point dy is 0.2 else 0
    //for curve end point dx is 0.8 else 1.0

    path.quadraticBezierTo(size.width * topRightCurveControlPointDx, size.height * topRightCurveControlPointDy, size.width * topRightCurveEndPointDx, size.height * topRightCurveEndPointDy);

    path.lineTo(size.width * (0.2), 0);

    //topLeft curve
    //for curve end point dy is 0.25 else 0
    path.quadraticBezierTo(size.width * topLeftCurveControlPointDx, size.height * topLeftCurveControlPointDy, size.width * topLeftCurveEndPointDx, size.height * topLeftCurveEndPointDy);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
