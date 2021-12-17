import 'dart:math';

import 'package:flutter/material.dart';

class SpinWheelScreen extends StatefulWidget {
  final Size screenSize;
  SpinWheelScreen({Key? key, required this.screenSize}) : super(key: key);

  @override
  _SpinWheelScreenState createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen> with TickerProviderStateMixin {
  late AnimationController spinWheelAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 5000));
  //..addStatusListener(spinWheelAnimationStatusListener)
  //..addListener(spinWheelAnimationListener);
  late Animation<double> spinWheelAnimation = Tween<double>(begin: 0, end: (numberOfRound * 360 + randomAngle)).animate(CurvedAnimation(parent: spinWheelAnimationController, curve: Curves.easeOut));

  late double heightAndWidth = widget.screenSize.width * 0.95; //Same as radius

  int numberOfSlice = 2;

  int numberOfRound = 5;

  int currentRoundNumber = 0;

  late double randomAngle = Random.secure().nextDouble() * 360;

  /*
  void spinWheelAnimationStatusListener(AnimationStatus animationStatus) {
    //
    if (animationStatus == AnimationStatus.dismissed || animationStatus == AnimationStatus.completed) {
      if (currentRoundNumber < numberOfRound) {
        spinWheelAnimationController.forward(from: 0.0);
      } else if (currentRoundNumber == numberOfRound) {
        spinWheelAnimationController.dispose();
        spinWheelAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
        spinWheelAnimation = Tween<double>(begin: 0, end: randomAngle).animate(CurvedAnimation(parent: spinWheelAnimationController, curve: Curves.easeOut));

        spinWheelAnimationController.forward(from: 0.0);
      }
    } else {
      currentRoundNumber++;
    }
  }
  */

/*
  void spinWheelAnimationListener() {
    if (currentRoundNumber == numberOfRound) {
      if (spinWheelAnimation.value > randomAngle) {
        print("Random angle is $randomAngle");
        spinWheelAnimationController.stop();
      }
    }
  }
  */

  @override
  void dispose() {
    //spinWheelAnimationController.removeListener(spinWheelAnimationListener);
    //spinWheelAnimationController.removeStatusListener(spinWheelAnimationStatusListener);
    spinWheelAnimationController.dispose();
    super.dispose();
  }

  Widget _buildSlice(double initialAngle, int index) {
    double arcAngle = (360 / numberOfSlice);
    return Align(
      alignment: Alignment.center,
      child: Container(
        child: CustomPaint(
          child: Container(
            padding: EdgeInsets.all(heightAndWidth * 0.14),
            height: heightAndWidth,
            width: heightAndWidth,
            child: Container(
              alignment: Alignment(cos((pi * (initialAngle + arcAngle * 0.5)) / 180), sin((pi * (initialAngle + arcAngle * 0.5)) / 180)), //
              child: Transform.rotate(angle: -((pi * spinWheelAnimation.value) / 180) * 2 * pi, child: Icon(Icons.person)),
            ),
          ),
          painter: ArcCustomPainter(arcColor: index.isEven ? Colors.greenAccent : Colors.pinkAccent, sweepAngle: (360 / numberOfSlice), initialAngle: initialAngle),
        ),
      ),
    );
  }

  List<Widget> _buildSlices() {
    //
    List<Widget> children = [];
    for (var i = 0; i < numberOfSlice; i++) {
      children.add(_buildSlice(i * (360 / numberOfSlice), i));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        if (spinWheelAnimationController.isCompleted) {
          spinWheelAnimationController.reverse();
        } else {
          spinWheelAnimationController.forward();
        }
      }),
      body: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: spinWheelAnimationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: (pi * spinWheelAnimation.value) / 180,
                  alignment: Alignment.center,
                  child: Container(
                    height: heightAndWidth,
                    width: heightAndWidth,
                    child: Stack(
                      children: [
                        ..._buildSlices(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Center(
            child: CircleAvatar(),
          ),

          /*
                    CustomPaint(
                      child: Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(
                            top: 150,
                            left: 150,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          height: heightAndWidth,
                          width: heightAndWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(45),
                            child: Icon(Icons.add),
                          )),
                      painter: ArcCustomPainter(arcColor: Colors.pinkAccent, sweepAngle: 90, initialAngle: 0),
                    ),
                    */

          // CustomPaint(
          //   child: Container(
          //     decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          //     padding: EdgeInsets.all(heightAndWidth * 0.14),
          //     height: heightAndWidth,
          //     width: heightAndWidth,
          //     child: Container(
          //       decoration: BoxDecoration(border: Border.all(color: Colors.green)),
          //       alignment: Alignment(cos((pi * 135) / 180), sin((pi * 135) / 180)), //
          //       child: Icon(Icons.person),
          //     ),
          //   ),
          //   painter: ArcCustomPainter(arcColor: Colors.greenAccent, sweepAngle: 90, initialAngle: 90),
          // ),

          // Center(
          //   child: Container(
          //     height: heightAndWidth,
          //     width: heightAndWidth,
          //     child: CustomPaint(
          //       child: Text("data"),
          //       painter: TestArcCustomPainter(arcColor: Colors.pinkAccent, sweepAngle: 90, initialAngle: 0),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class TestArcCustomPainter extends CustomPainter {
  final double sweepAngle;
  final double initialAngle;
  final Color arcColor;

  TestArcCustomPainter({required this.sweepAngle, required this.initialAngle, required this.arcColor});

  double _degreeToRadian() {
    return (sweepAngle * pi) / 180.0;
  }

  double _initialAngleToRadin() {
    return (initialAngle * pi) / 180.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 11
      ..color = arcColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    Path path = Path();

    path.arcTo(Rect.fromCircle(center: Offset(size.width * (0.5), size.height * (0.5)), radius: size.width * (0.5)), 0, sweepAngle, false);

    canvas.clipPath(path);

    //canvas.drawArc(Rect.fromCircle(center: Offset(size.width * (0.5), size.height * (0.5)), radius: size.width * 0.5), _initialAngleToRadin(), _degreeToRadian(), true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ArcCustomPainter extends CustomPainter {
  final double sweepAngle;
  final double initialAngle;
  final Color arcColor;

  ArcCustomPainter({required this.sweepAngle, required this.initialAngle, required this.arcColor});

  double _degreeToRadian() {
    return (sweepAngle * pi) / 180.0;
  }

  double _initialAngleToRadin() {
    return (initialAngle * pi) / 180.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 11
      ..color = arcColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;
    canvas.drawArc(Rect.fromCircle(center: Offset(size.width * (0.5), size.height * (0.5)), radius: size.width * 0.5), _initialAngleToRadin(), _degreeToRadian(), true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
