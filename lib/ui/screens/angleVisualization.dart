import 'dart:math';

import 'package:flutter/material.dart';

class AngleVisualization extends StatefulWidget {
  AngleVisualization({Key? key}) : super(key: key);

  @override
  _AngleVisualizationState createState() => _AngleVisualizationState();
}

class _AngleVisualizationState extends State<AngleVisualization> with TickerProviderStateMixin {
  late AnimationController animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
  late Animation<double> animation = Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
  late double containerSizeInAlignment = 1.4;
  late AnimationController outerArcAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1200));
  late Animation<double> outerArcAnimation = Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(parent: outerArcAnimationController, curve: Curves.easeInOut));

  late AnimationController firstArcAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
  late Animation<double> firstArcAnimation = Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(parent: firstArcAnimationController, curve: Curves.easeInOut));

  //late AnimationController animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
  //late Animation<double> animation = Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));

  bool isLeftSide(double angleInDegree) {
    if (angleInDegree > 90 && angleInDegree < 270) {
      return true;
    }
    return false;
  }

  double toRadian(double angleInDegree) {
    return ((pi / 180) * angleInDegree);
  }

  @override
  void dispose() {
    animationController.dispose();
    outerArcAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double dwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                if (outerArcAnimationController.isCompleted) {
                  animationController.reverse();
                  await Future.delayed(Duration(milliseconds: 300));
                  outerArcAnimationController.reverse();
                } else {
                  outerArcAnimationController.forward();
                  await Future.delayed(Duration(milliseconds: 300));

                  animationController.forward();
                }
              },
              icon: Icon(Icons.play_arrow))
        ],
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: -dwidth * (containerSizeInAlignment / 4),
            left: dwidth * 0.15,
            child: Container(
                height: dwidth * (containerSizeInAlignment / 2),
                width: dwidth * (containerSizeInAlignment / 2),
                child: AnimatedBuilder(
                  animation: firstArcAnimationController,
                  builder: (context, child) {
                    double angle = firstArcAnimation.drive<double>(Tween(begin: 0.0, end: 180)).value;
                    return CustomPaint(
                      painter: AngleArc(color: Colors.pink.shade100, angle: angle),
                    );
                  },
                )),
          ),
          Positioned(
            bottom: -dwidth * (containerSizeInAlignment / 4),
            left: dwidth * 0.15,
            child: Container(
                height: dwidth * (containerSizeInAlignment / 2),
                width: dwidth * (containerSizeInAlignment / 2),
                child: AnimatedBuilder(
                  animation: outerArcAnimationController,
                  builder: (context, child) {
                    double outerArcAngle = outerArcAnimation.drive<double>(Tween(begin: 0.0, end: 180)).value;
                    return CustomPaint(
                      child: Center(
                        child: Container(
                          height: dwidth * ((containerSizeInAlignment - 0.35) / 2),
                          width: dwidth * ((containerSizeInAlignment - 0.35) / 2),
                          child: CustomPaint(
                            child: Stack(
                              children: [
                                AnimatedBuilder(
                                  animation: animationController,
                                  builder: (context, child) {
                                    double angleX = animation.drive<double>(Tween(begin: 180, end: 0.0)).value;
                                    double angleY = animation.drive<double>(Tween(begin: 190, end: 25)).value;
                                    return Align(
                                        alignment: Alignment(cos(-1 * toRadian(angleX)), sin(-1 * toRadian(angleY))),
                                        child: Container(
                                          decoration: BoxDecoration(color: Colors.purpleAccent, borderRadius: BorderRadius.circular(dwidth * 0.15 * (0.5))),
                                          height: dwidth * (0.15 / 2),
                                          width: dwidth * (0.15 / 2),
                                        ));
                                  },
                                ),
                                AnimatedBuilder(
                                  animation: animationController,
                                  builder: (context, child) {
                                    double angleX = animation.drive<double>(Tween(begin: 270, end: 90)).value;
                                    double angleY = animation.drive<double>(Tween(begin: 270, end: 90)).value;
                                    return Align(
                                        alignment: Alignment(cos(-1 * toRadian(angleX)), sin(-1 * toRadian(angleY))),
                                        child: Container(
                                          decoration: BoxDecoration(color: Colors.purpleAccent, borderRadius: BorderRadius.circular(dwidth * 0.15 * (0.5))),
                                          height: dwidth * (0.15 / 2),
                                          width: dwidth * (0.15 / 2),
                                        ));
                                  },
                                ),
                                AnimatedBuilder(
                                  animation: animationController,
                                  builder: (context, child) {
                                    double angleX = animation.drive<double>(Tween(begin: 0, end: 180)).value;
                                    double angleY = animation.drive<double>(Tween(begin: 335, end: 155)).value;
                                    return Align(
                                        alignment: Alignment(cos(-1 * toRadian(angleX)), sin(-1 * toRadian(angleY))),
                                        child: Container(
                                          decoration: BoxDecoration(color: Colors.purpleAccent, borderRadius: BorderRadius.circular(dwidth * 0.15 * (0.5))),
                                          height: dwidth * (0.15 / 2),
                                          width: dwidth * (0.15 / 2),
                                        ));
                                  },
                                ),
                              ],
                            ),
                            painter: AngleArc(color: Colors.transparent, angle: 180.0),
                          ),
                        ),
                      ),
                      painter: AngleArc(color: Colors.red.shade100, angle: outerArcAngle),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}

class AngleArc extends CustomPainter {
  final Color color;
  final double angle;
  AngleArc({required this.color, required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    //Paint linePaint = Paint()
    //..color = Colors.white
    //..strokeWidth = 2.5;
    double radius = size.width * (0.5);

    canvas.drawArc(Rect.fromCircle(center: Offset(size.width * (0.5), size.height * (0.5)), radius: radius), pi, (pi / 180) * angle, true, paint);
    //X axis
    //canvas.drawLine(Offset(size.width * (0.0), size.height * (0.5)), Offset(size.width, size.height * (0.5)), linePaint..strokeWidth = 2.5);

    //Y axis
    //canvas.drawLine(Offset(size.width * (0.5), size.height * (0)), Offset(size.width * (0.5), size.height), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
