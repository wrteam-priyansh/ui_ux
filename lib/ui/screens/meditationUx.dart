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

  List<int> dataList = [8, 7, 6, 5, 4, 3, 2, 1]; //

  List<Color> color = [Colors.blue, Colors.purple, Colors.cyan, Colors.orange, Colors.pink, Colors.yellow, Colors.green, Colors.indigoAccent];

  late double heightPercentage = 0.45;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < dataList.length; i++) {
      animationControllers.add(AnimationController(vsync: this, duration: Duration(milliseconds: 1000)));
      animations.add(Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationControllers[i], curve: Curves.easeInOutSine)));
    }
  }

  @override
  void dispose() {
    animationControllers.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  double _calculateCardTopPosition(int cardIndex) {
    double topPosition;

    if (cardIndex > 3) {
      topPosition = 5.0;
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

  double _calculateCardScale(int cardIndex) {
    double scale = 0.2;
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
      animation: animationControllers[cardIndex],
      builder: (context, child) {
        double topPosition = animations[cardIndex]
            .drive(Tween<double>(
              begin: _calculateCardTopPosition(cardIndex),
              end: cardIndex > 3 ? _calculateCardTopPosition(cardIndex + 5) : _calculateCardTopPosition(cardIndex + 4),
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
              transform: Matrix4.identity()..rotateX((pi / 180) * angle),
              child: cardIndex == 0 || cardIndex == 4
                  ? Container(
                      alignment: Alignment.center,
                      child: Text("${dataList[cardIndex]}"),
                      height: MediaQuery.of(context).size.height * heightPercentage,
                      width: MediaQuery.of(context).size.width,
                      color: color[cardIndex],
                    )
                  : CustomPaint(
                      painter: CardCurve(color[cardIndex]),
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
        for (var i = dataList.length - 1; i >= 0; i--) {
          await Future.delayed(Duration(milliseconds: 100));
          animationControllers[i].forward();
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
