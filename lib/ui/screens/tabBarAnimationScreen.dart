import 'dart:math';

import 'package:flutter/material.dart';

class TabBarAnimationScreen extends StatefulWidget {
  TabBarAnimationScreen({Key? key}) : super(key: key);

  @override
  _TabBarAnimationScreenState createState() => _TabBarAnimationScreenState();
}

class _TabBarAnimationScreenState extends State<TabBarAnimationScreen> with TickerProviderStateMixin {
  late AnimationController animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1250));
  late Animation<double> animation = Tween<double>(begin: 0, end: 180).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
  late Animation<double> secondAnimation = Tween<double>(begin: 0, end: 180).animate(CurvedAnimation(
    parent: animationController,
    curve: Interval(0.3, 1.0, curve: Curves.easeInOut),
  ));
  late Animation<double> thirdAnimation = Tween<double>(begin: 0, end: 180).animate(CurvedAnimation(
    parent: animationController,
    curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
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
              height: MediaQuery.of(context).size.width * (0.34),
              width: MediaQuery.of(context).size.width * (0.34),
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
                        Align(alignment: Alignment.topCenter, child: Icon(Icons.add)),
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
