import 'package:flutter/material.dart';

class MeditationUx extends StatefulWidget {
  MeditationUx({Key? key}) : super(key: key);

  @override
  _MeditationUxState createState() => _MeditationUxState();
}

class _MeditationUxState extends State<MeditationUx> with TickerProviderStateMixin {
  //for animating the first menu
  late List<AnimationController> animationControllers = [];

  late List<Animation<double>> animations = [];
  //for animating the second menu

  late List<AnimationController> secondAnimationControllers = [];

  late List<Animation<double>> secondAnimations = [];

  List<String> dataList = [
    "assets/images/image.png",
    "assets/images/image-1.png",
    "assets/images/image-2.png",
    "assets/images/image-3.png",
    "assets/images/image.png",
    "assets/images/image-1.png",
    "assets/images/image-2.png",
    "assets/images/image-3.png",
    "assets/images/image.png",
    "assets/images/image-1.png",
    "assets/images/image-2.png",
    "assets/images/image-3.png",
  ];

  //to open and close the card details
  late AnimationController toggleCardDetailsAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 750));

  late Animation<double> toggleCardDetailsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: toggleCardDetailsAnimationController, curve: Curves.easeInOutSine));

  List<Color> color = [Colors.blue, Colors.purple, Colors.cyan, Colors.orange, Colors.pink, Colors.yellow, Colors.green, Colors.indigoAccent, Colors.blue, Colors.purple, Colors.cyan, Colors.orange];
  List<GlobalKey> customPainterKeys = [];

  late double heightPercentage = 0.5;
  late double spacingBetweenTwoCards = 0.45; //in percentage

  late bool isCardDetailsOpen = false;
  late int selectedCardMenuIndex = -1;

  late AnimationController cardDetailsTopMenuAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
  late Animation<double> cardDetailsTopMenuAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: cardDetailsTopMenuAnimationController, curve: Curves.easeInOutSine));

  late int currentMenu = 3; // will have two menu 1, 2 and 3

  @override
  void initState() {
    super.initState();
    initAnimations();
  }

  //initAnimations
  void initAnimations() {
    for (var i = 0; i < dataList.length; i++) {
      animationControllers.add(AnimationController(vsync: this, duration: Duration(milliseconds: 1000)));
      animations.add(Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationControllers[i], curve: Curves.easeInOutSine)));
      secondAnimationControllers.add(AnimationController(vsync: this, duration: Duration(milliseconds: 1000)));
      secondAnimations.add(Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: secondAnimationControllers[i], curve: Curves.easeInOutSine)));
      customPainterKeys.add(GlobalKey());
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

  //
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

  //
  double _calculateEndTopPositionForCard(int cardIndex) {
    if (cardIndex > 7) {
      return _calculateBeginTopPositionForCard(cardIndex + 5);
    }
    return _calculateBeginTopPositionForCard(cardIndex + 4);
  }

  //
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

  void openCardDetails(int cardIndex) async {
    //if card already opened then do nothing
    if (isCardDetailsOpen) {
      return;
    }
    setState(() {
      selectedCardMenuIndex = cardIndex;
      isCardDetailsOpen = true;
    });
    await toggleCardDetailsAnimationController.forward();

    cardDetailsTopMenuAnimationController.forward();
  }

  void closeCardDetails() async {
    await cardDetailsTopMenuAnimationController.reverse();
    await toggleCardDetailsAnimationController.reverse();
    setState(() {
      selectedCardMenuIndex = -1;
      isCardDetailsOpen = false;
    });
  }

  bool isFirstMenuScrolling() {
    bool isScrolling = false;
    for (var animationController in animationControllers) {
      if (animationController.isAnimating) {
        isScrolling = true;
        break;
      }
    }
    return isScrolling;
  }

  bool isSecondMenuScrolling() {
    bool isScrolling = false;
    for (var animationController in secondAnimationControllers) {
      if (animationController.isAnimating) {
        isScrolling = true;
        break;
      }
    }
    return isScrolling;
  }

  void onVerticalDragEnd(DragEndDetails dragEndDetails) async {
    double primaryVelocity = dragEndDetails.primaryVelocity ?? 0;
    if (primaryVelocity < 0) {
      print("Up Direction");
      //first menu start with 0 to 3
      if (currentMenu == 1) {
        if (isSecondMenuScrolling()) {
          return;
        }
        for (var i = 0; i < 8; i++) {
          await Future.delayed(Duration(milliseconds: 100));
          //To aovid repeat animation

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
        if (isFirstMenuScrolling()) {
          return;
        }
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
        if (isFirstMenuScrolling()) {
          return;
        }
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
        if (isSecondMenuScrolling()) {
          return;
        }
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
                            child: GestureDetector(
                              onVerticalDragEnd: onVerticalDragEnd,
                              onTap: () {
                                print("Card index $cardIndex");
                                openCardDetails(cardIndex);
                              },
                              onTapUp: (tapUpDetails) {},
                              child: ClipPath(
                                key: customPainterKeys[cardIndex],
                                clipper: CardCurve(
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
                                  child: Container(
                                    color: Colors.black26,
                                  ),
                                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage(dataList[cardIndex]), fit: BoxFit.cover)),
                                  height: MediaQuery.of(context).size.height * heightPercentage,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                            ))
                        : Positioned(
                            top: topPosition,
                            child: GestureDetector(
                              onVerticalDragEnd: onVerticalDragEnd,
                              onTap: () {
                                print("Card index $cardIndex");
                                openCardDetails(cardIndex);
                              },
                              child: ClipPath(
                                key: customPainterKeys[cardIndex],
                                clipper: CardCurve(
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
                                  child: Container(
                                    color: Colors.black26,
                                  ),
                                  decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage(dataList[cardIndex]))),
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

  List<Widget> _buildCards() {
    final List<Widget> children = [];
    for (var i = 0; i < dataList.length; i++) {
      children.add(_buildCard(i));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (cardDetailsTopMenuAnimationController.isCompleted) {
          closeCardDetails();
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        body: Stack(
          children: [
            //to build cards
            ..._buildCards(),
            //to build bottom nav bar
            _buildBottomNavBar(),
            //to build top card menu that contains like, share and back button
            _buildCardTopMenu(),
          ],
        ),
      ),
    );
  }
}

class CardCurve extends CustomClipper<Path> {
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
  late Path path;

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
  }) {
    path = Path();
  }

  @override
  Path getClip(Size size) {
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

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
