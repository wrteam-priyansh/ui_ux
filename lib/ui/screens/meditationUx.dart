import 'dart:math';

import 'package:flutter/material.dart';

class MeditationUx extends StatefulWidget {
  MeditationUx({Key? key}) : super(key: key);

  @override
  _MeditationUxState createState() => _MeditationUxState();
}

class _MeditationUxState extends State<MeditationUx> with TickerProviderStateMixin {
  late AnimationController animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1600));
  late List<Animation<double>> animations = [];

  List<int> dataList = [4, 3, 2, 1];

  List<Color> color = [Colors.blue, Colors.purple, Colors.cyan, Colors.orange];

  late int currentSubMenu = 1;

  @override
  void initState() {
    super.initState();
    for (var i = 3; i >= 0; i--) {
      animations.add(Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Interval(i * 0.1, 0.54 + (i * 0.115), curve: Curves.easeInOutSine))));
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  double _calculateCardTopPosition(int cardIndex) {
    double topPosition = cardIndex > 3 ? 5.0 : 0.0;
    if (currentSubMenu == 1) {
      for (var i = 0; i < cardIndex; i++) {
        if (cardIndex > 3) {
          topPosition = topPosition - MediaQuery.of(context).size.height * (0.20);
        } else {
          topPosition = topPosition + MediaQuery.of(context).size.height * (0.20);
        }
      }
    }
    return topPosition;
  }

  double _calculateCardScale(int cardIndex) {
    double scale = 0.6;
    for (var i = 0; i <= cardIndex; i++) {
      scale = scale + 0.1;
    }
    return scale;
  }

  double _calculateAngle(int cardIndex) {
    double angle = 2;
    for (var i = 0; i <= cardIndex; i++) {
      angle = angle + 2;
    }
    return angle;
  }

  Widget _buildCard(int cardIndex) {
    _calculateCardTopPosition(cardIndex);

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        double topPosition = animations[cardIndex]
            .drive(Tween<double>(
              begin: _calculateCardTopPosition(cardIndex),
              end: MediaQuery.of(context).size.height,
            ))
            .value;

        double scale = animations[cardIndex]
            .drive(Tween<double>(
              begin: _calculateCardScale(cardIndex),
              end: 1.0,
            ))
            .value;
        double angle = animations[cardIndex]
            .drive(Tween<double>(
              begin: _calculateAngle(cardIndex),
              end: 0.0,
            ))
            .value;

        return Positioned(
            top: topPosition,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateX((pi / 180) * angle)
                ..scale(scale),
              child: CustomPaint(
                painter: CardCurve(color[cardIndex]),
                child: Container(
                  alignment: Alignment.center,
                  child: Text("${dataList[cardIndex]}"),
                  height: MediaQuery.of(context).size.height * (0.4),
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
      floatingActionButton: FloatingActionButton(onPressed: () {
        if (animationController.isCompleted) {
          animationController.reverse();
        } else {
          animationController.forward();
        }
      }),
      body: Stack(
        children: [...dataList.map((e) => _buildCard(dataList.indexOf(e))).toList()],
      ),
    );
  }
}

class CardCurve extends CustomPainter {
  final Color color;
  CardCurve(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = color;
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * (0.5));

    path.quadraticBezierTo(size.width, size.height * (0.275), size.width * (0.8), size.height * (0.2));
    path.lineTo(size.width * (0.2), 0);

    path.quadraticBezierTo(0, 0, 0, size.height * (0.25));
    path.close();
    canvas.drawPath(path, paint);
    //canvas.drawShadow(, Colors.black26, 5.0, true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
