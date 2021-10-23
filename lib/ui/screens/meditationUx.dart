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

  late AnimationController animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  late Animation<double> animation = Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));

  List<int> dataList = [8, 7, 6, 5, 4, 3, 2, 1]; //

  late AnimationController menuAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

  late AnimationController curveAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
  late List<Animation<double>> curveAnimations = [];

  List<Color> color = [Colors.blue, Colors.purple, Colors.cyan, Colors.orange, Colors.pink, Colors.yellow, Colors.green, Colors.indigoAccent];

  late double heightPercentage = 0.45;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < dataList.length; i++) {
      animationControllers.add(AnimationController(vsync: this, duration: Duration(milliseconds: 1000)));
      animations.add(Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationControllers[i], curve: Curves.easeInOutSine)));
      if (i == 0) {
        curveAnimations.add(Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: curveAnimationController, curve: Curves.easeInOut)));
      } else if (i == 4) {
        curveAnimations.add(Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: curveAnimationController, curve: Curves.easeInOut)));
      }
      //
    }
  }

  @override
  void dispose() {
    animationControllers.forEach((element) {
      element.dispose();
    });
    animationController.dispose();
    curveAnimationController.dispose();
    super.dispose();
  }

  double _calculateCardTopPosition(int cardIndex) {
    double topPosition;

    if (cardIndex > 3) {
      topPosition = 0.0;
      for (var i = 4; i < cardIndex; i++) {
        topPosition = topPosition + MediaQuery.of(context).size.height * (heightPercentage * (0.5));
      }
    } else {
      topPosition = -MediaQuery.of(context).size.height * heightPercentage;
      for (var i = cardIndex; i < 3; i++) {
        topPosition = topPosition - MediaQuery.of(context).size.height * (heightPercentage * (0.1));
      }
    }

    return topPosition;
  }

  // double _calculateCardScale(int cardIndex) {
  //   double scale = 0.2;
  //   for (var i = 0; i <= cardIndex; i++) {
  //     scale = scale + 0.1;
  //   }
  //   return scale;
  // }

  // double _calculateAngle(int cardIndex) {
  //   double angle = 2;
  //   for (var i = 0; i <= cardIndex; i++) {
  //     angle = angle + 2;
  //   }
  //   return angle;
  // }

  Widget _buildCard(int cardIndex) {
    _calculateCardTopPosition(cardIndex);

    return AnimatedBuilder(
      animation: animationControllers[cardIndex],
      builder: (context, child) {
        double topPosition = animations[cardIndex]
            .drive(Tween<double>(
              begin: _calculateCardTopPosition(cardIndex),
              end: cardIndex > 3 ? _calculateCardTopPosition(cardIndex + 5) : _calculateCardTopPosition(cardIndex + 4),
            ))
            .value;

        // double angle = animations[cardIndex]
        //     .drive(Tween<double>(
        //       begin: _calculateAngle(cardIndex),
        //       end: 0.0,
        //     ))
        //     .value;

        return cardIndex == 4 || cardIndex == 0
            ? AnimatedBuilder(
                animation: curveAnimationController,
                builder: (context, _) {
                  final curveAnimation = cardIndex == 0 ? curveAnimations.first : curveAnimations.last;
                  final double topRightCurveControlPointDy = curveAnimation.drive(Tween<double>(begin: 0.275, end: 0.0)).value;
                  final double topRightCurveControlPointDx = curveAnimation.drive(Tween<double>(begin: 1.0, end: 1.0)).value;
                  final double topRightCurveEndPointDy = curveAnimation.drive(Tween<double>(begin: 0.2, end: 0.0)).value;
                  final double topRightCurveEndPointDx = curveAnimation.drive(Tween<double>(begin: 0.8, end: 1.0)).value;
                  final double topLeftCurveControlPointDy = curveAnimation.drive(Tween<double>(begin: 0, end: 0.0)).value;
                  final double topLeftCurveControlPointDx = curveAnimation.drive(Tween<double>(begin: 0, end: 0)).value;
                  final double topLeftCurveEndPointDy = curveAnimation.drive(Tween<double>(begin: 0.25, end: 0.0)).value;
                  final double topLeftCurveEndPointDx = curveAnimation.drive(Tween<double>(begin: 0, end: 0)).value;

                  return Positioned(
                      top: topPosition,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateX((pi / 180) * 0),
                        child: CustomPaint(
                          painter: CardCurve(
                            color: color[cardIndex],
                            topLeftCurveControlPointDx: topLeftCurveControlPointDx,
                            topLeftCurveControlPointDy: topLeftCurveControlPointDy,
                            topLeftCurveEndPointDx: topLeftCurveEndPointDx,
                            topLeftCurveEndPointDy: topLeftCurveEndPointDy,
                            topRightCurveControlPointDy: topRightCurveControlPointDy,
                            topRightCurveControlPointDx: topRightCurveControlPointDx,
                            topRightCurveEndPointDx: topRightCurveEndPointDx,
                            topRightCurveEndPointDy: topRightCurveEndPointDy,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text("${dataList[cardIndex]}"),
                            height: MediaQuery.of(context).size.height * heightPercentage,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ));
                })
            : Positioned(
                top: topPosition,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateX((pi / 180) * 0),
                  child: CustomPaint(
                    painter: CardCurve(
                      color: color[cardIndex],
                      topLeftCurveControlPointDx: 0,
                      topLeftCurveControlPointDy: 0,
                      topLeftCurveEndPointDx: 0,
                      topLeftCurveEndPointDy: 0.25,
                      topRightCurveControlPointDy: 0.275,
                      topRightCurveControlPointDx: 1.0,
                      topRightCurveEndPointDx: 0.8,
                      topRightCurveEndPointDy: 0.2,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text("${dataList[cardIndex]}"),
                      height: MediaQuery.of(context).size.height * heightPercentage,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        if (animationController.isCompleted) {
          animationController.reverse();
        } else {
          animationController.forward();
        }

        /*
        if (animationControllers.last.isCompleted) {
          for (var i = 0; i < dataList.length; i++) {
            await Future.delayed(Duration(milliseconds: 100));
            if (i == 4) {
              curveAnimationController.reverse();
            }
            animationControllers[i].reverse();
          }
        } else {
          for (var i = dataList.length - 1; i >= 0; i--) {
            await Future.delayed(Duration(milliseconds: 100));
            if (i == 4) {
              curveAnimationController.forward();
            }
            animationControllers[i].forward();
          }
        }
        */
      }),
      body: Stack(
        children: [
          //...dataList.map((e) => _buildCard(dataList.indexOf(e))).toList()

          Center(
            child: AnimatedBuilder(
                animation: animationController,
                builder: (context, _) {
                  final double topRightCurveControlPointDy = animation.drive(Tween<double>(begin: 0.275, end: 0.0)).value;
                  final double topRightCurveControlPointDx = animation.drive(Tween<double>(begin: 1.0, end: 1.0)).value;
                  final double topRightCurveEndPointDy = animation.drive(Tween<double>(begin: 0.2, end: 0.0)).value;
                  final double topRightCurveEndPointDx = animation.drive(Tween<double>(begin: 0.8, end: 1.0)).value;
                  final double topLeftCurveControlPointDy = animation.drive(Tween<double>(begin: 0, end: 0.0)).value;
                  final double topLeftCurveControlPointDx = animation.drive(Tween<double>(begin: 0, end: 0)).value;
                  final double topLeftCurveEndPointDy = animation.drive(Tween<double>(begin: 0.25, end: 0.0)).value;
                  final double topLeftCurveEndPointDx = animation.drive(Tween<double>(begin: 0, end: 0)).value;

                  return CustomPaint(
                    painter: CardCurve(
                      topLeftCurveControlPointDx: topLeftCurveControlPointDx,
                      topLeftCurveControlPointDy: topLeftCurveControlPointDy,
                      topLeftCurveEndPointDx: topLeftCurveEndPointDx,
                      topLeftCurveEndPointDy: topLeftCurveEndPointDy,
                      topRightCurveControlPointDy: topRightCurveControlPointDy,
                      topRightCurveControlPointDx: topRightCurveControlPointDx,
                      topRightCurveEndPointDx: topRightCurveEndPointDx,
                      topRightCurveEndPointDy: topRightCurveEndPointDy,
                      color: color.first,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * heightPercentage,
                      width: MediaQuery.of(context).size.width,
                    ),
                  );
                }),
          )
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

  CardCurve({
    required this.color,
    required this.topLeftCurveControlPointDx,
    required this.topLeftCurveControlPointDy,
    required this.topLeftCurveEndPointDx,
    required this.topLeftCurveEndPointDy,
    required this.topRightCurveControlPointDx,
    required this.topRightCurveControlPointDy,
    required this.topRightCurveEndPointDx,
    required this.topRightCurveEndPointDy,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = color;
    Path path = Path();

    //
    path.moveTo(0, size.height * (0.5));
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * (0.5));

    path.quadraticBezierTo(size.width * topRightCurveControlPointDx, size.height * topRightCurveControlPointDy, size.width * topRightCurveEndPointDx, size.height * topRightCurveEndPointDy);

    path.lineTo(size.width * (0.2), 0);
    path.quadraticBezierTo(size.width * topLeftCurveControlPointDx, size.height * topLeftCurveControlPointDy, size.width * topLeftCurveEndPointDx, size.height * topLeftCurveEndPointDy);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
