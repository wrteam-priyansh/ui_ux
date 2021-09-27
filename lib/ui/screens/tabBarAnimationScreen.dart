import 'dart:math';

import 'package:flutter/material.dart';

class TabBarAnimationScreen extends StatefulWidget {
  TabBarAnimationScreen({Key? key}) : super(key: key);

  @override
  _TabBarAnimationScreenState createState() => _TabBarAnimationScreenState();
}

class _TabBarAnimationScreenState extends State<TabBarAnimationScreen> with TickerProviderStateMixin {
  late AnimationController animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 4000));
  late Animation<double> animation = Tween<double>(begin: 0, end: 180).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
  late Animation<double> secondAnimation = Tween<double>(begin: 0, end: 180).animate(CurvedAnimation(
    parent: animationController,
    curve: Interval(0.3, 1.0, curve: Curves.easeInOut),
  ));
  late Animation<double> thirdAnimation = Tween<double>(begin: 0, end: 180).animate(CurvedAnimation(
    parent: animationController,
    curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
  ));
  late Animation<double> iconAnimation = Tween<double>(begin: 150, end: 360).animate(CurvedAnimation(
    parent: animationController,
    curve: Interval(0.6, 1.0, curve: Curves.easeInOut),
  ));
  late Animation<double> iconPaddingX = Tween<double>(begin: -0.25, end: 0.25).animate(CurvedAnimation(
    parent: animationController,
    curve: Interval(0.6, 1.0, curve: Curves.easeInOut),
  ));
  late Animation<double> iconPaddingFirstY = Tween<double>(begin: 0.5, end: 0.0).animate(CurvedAnimation(
    parent: animationController,
    curve: Interval(0.7, 0.85, curve: Curves.easeInOut),
  ));
  late Animation<double> iconPaddingSecondY = Tween<double>(begin: 0.0, end: 0.5).animate(CurvedAnimation(
    parent: animationController,
    curve: Interval(0.85, 1.0, curve: Curves.easeInOut),
  ));
  late Animation<double> secondIconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    parent: animationController,
    curve: Interval(0.7, 1.0, curve: Curves.easeInOut),
  ));
  late Animation<double> thirdIconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    parent: animationController,
    curve: Interval(0.7, 1.0, curve: Curves.easeInOut),
  ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(onPressed: () {
        if (animationController.isCompleted) {
          animationController.reverse();
        } else {
          animationController.forward();
        }
      }),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: MediaQuery.of(context).size.width * (0.3),
              width: MediaQuery.of(context).size.width * (0.3),
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: CustomArc(
                      angle: animation.value,
                      color: Colors.yellow,
                    ),
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: MediaQuery.of(context).size.width * (0.32),
              width: MediaQuery.of(context).size.width * (0.32),
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: CustomArc(
                      angle: secondAnimation.value,
                      color: Colors.pinkAccent,
                    ),
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: MediaQuery.of(context).size.width * (0.35),
              width: MediaQuery.of(context).size.width * (0.35),
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: CustomArc(
                      angle: thirdAnimation.value,
                      color: Colors.white,
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment(cos((pi / 180) * iconAnimation.value) - (iconPaddingX.value), sin((pi / 180) * iconAnimation.value) - iconPaddingFirstY.value - iconPaddingSecondY.value),
                          child: Icon(Icons.add),
                        ),
                        AnimatedBuilder(
                            animation: animationController,
                            builder: (context, child) {
                              double angle = secondIconAnimation.drive<double>(Tween<double>(begin: 90, end: 270)).value;
                              return Align(
                                alignment: Alignment(cos((pi / 180) * angle), sin((pi / 180) * angle) + 0.15),
                                child: Icon(Icons.add),
                              );
                            }),
                        AnimatedBuilder(
                            animation: animationController,
                            builder: (context, child) {
                              double angle = thirdIconAnimation.drive<double>(Tween<double>(begin: 30, end: 180)).value;
                              return Align(
                                alignment: Alignment(cos((pi / 180) * angle) + 0.25, sin((pi / 180) * angle) - 0.5),
                                child: Icon(Icons.add),
                              );
                            }),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomArc extends CustomPainter {
  final double angle;
  final Color color;
  CustomArc({required this.angle, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;

    canvas.drawArc(Rect.fromCircle(center: Offset(size.width * (0.5), size.height * (0.5)), radius: size.width * (0.5)), (pi / 180) * (180), (pi / 180) * (angle), true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
