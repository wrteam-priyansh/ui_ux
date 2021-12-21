import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:math' as Math;

/*
To generate bearer token

final claimSet = new JwtClaim(issuer: 'Quiz', subject: 'Quiz Authentication', maxAge: const Duration(minutes: 5), issuedAt: DateTime.now().toUtc());
        String token = issueJwtHS256(claimSet, "2000");
        print(token);

 */

class SpinWheelScreen extends StatefulWidget {
  final Size screenSize;
  SpinWheelScreen({Key? key, required this.screenSize}) : super(key: key);

  @override
  _SpinWheelScreenState createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen>
    with TickerProviderStateMixin {
  late AnimationController spinWheelAnimationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 5000));

  late Animation<double> spinWheelAnimation =
      Tween<double>(begin: 0, end: (360 * 5) + randomAngle).animate(
          CurvedAnimation(
              parent: spinWheelAnimationController, curve: Curves.easeOut));

  late double heightAndWidth =
      widget.screenSize.width * (0.4); //radius will be half of this

  int numberOfSlice = 8;

  late double randomAngle = 300; //Random.secure().nextDouble() * 360;

  late double sliceAngle = 360 / numberOfSlice;

  late double spinArrowSize = 25.0;

  @override
  void dispose() {
    spinWheelAnimationController.dispose();
    super.dispose();
  }

  Widget _buildSlice(int index) {
    double fontSize = 13.0; //
    return AnimatedBuilder(
        animation: spinWheelAnimationController,
        builder: (context, child) {
          return Transform.rotate(
            alignment: Alignment.topLeft,
            angle:
                _degreeToRadian(sliceAngle * index + spinWheelAnimation.value),
            child: CustomPaint(
              //
              child: Container(
                height: heightAndWidth,
                width: heightAndWidth,
                padding: EdgeInsets.only(right: 20.0),
                child: Transform.rotate(
                  alignment: Alignment.topLeft,
                  angle: _degreeToRadian(sliceAngle * (0.5)),
                  child: Container(
                    alignment: Alignment.topRight,
                    child: Transform.translate(
                      offset: Offset(0.0, -fontSize * (0.5)),
                      child: Text(
                        "Some Data $index",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize,
                            height: 1.0),
                      ),
                    ),
                  ),
                ),
              ),
              painter: ArcCustomPainter(
                  angle: sliceAngle,
                  arcColor:
                      index.isEven ? Colors.redAccent : Colors.pinkAccent),
            ),
          );
        });
  }

  List<Widget> _buildSlices() {
    //
    List<Widget> children = [];
    for (var i = 0; i < numberOfSlice; i++) {
      children.add(_buildSlice(i));
    }
    return children;
  }

  double _degreeToRadian(double angle) {
    return (pi * angle) / 180;
  }

  double _calculateCurrentSliceAngle(int index) {
    return ((index * sliceAngle) + spinWheelAnimation.value);
  }

  double _selectedSpinValueAngleLowerRange(int angle) {
    return angle - sliceAngle * (0.5);
  }

  double _selectedSpinValueAngleUpperRange(int angle) {
    return angle + sliceAngle * (0.5);
  }

  int _calculateSliceIndexesInRange() {
    int selectedIndex = 0;
    List<Map<String, dynamic>> angles = [];
    for (var i = 0; i < numberOfSlice; i++) {
      var currentAngle = _calculateCurrentSliceAngle(i) - 360 * 5;
      if (currentAngle >= _selectedSpinValueAngleLowerRange(270) &&
          currentAngle <= _selectedSpinValueAngleUpperRange(270)) {
        angles.add(
          {"index": i, "angleArea": false},
        );
      }

      if ((currentAngle + sliceAngle) >
              _selectedSpinValueAngleLowerRange(270) &&
          (currentAngle + sliceAngle) <
              _selectedSpinValueAngleUpperRange(270)) {
        bool alreadyAdded = angles
            .where((element) => element['index'] == i)
            .toList()
            .isNotEmpty;
        if (!alreadyAdded) {
          angles.add(
            {"index": i, "angleArea": true},
          );
        }
      }

      if (currentAngle >= _selectedSpinValueAngleLowerRange(630) &&
          currentAngle <= _selectedSpinValueAngleUpperRange(630)) {
        angles.add(
          {"index": i, "angleArea": false},
        );
      }

      if ((currentAngle + sliceAngle) >
              _selectedSpinValueAngleLowerRange(630) &&
          (currentAngle + sliceAngle) <
              _selectedSpinValueAngleUpperRange(630)) {
        bool alreadyAdded = angles
            .where((element) => element['index'] == i)
            .toList()
            .isNotEmpty;
        if (!alreadyAdded) {
          angles.add(
            {"index": i, "angleArea": true},
          );
        }
      }

      //
    }

    angles.forEach((element) {
      print(element.toString());
    });

    //if (angles.length == 1) {}

    return selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        await spinWheelAnimationController.forward();

        print("Random angle is $randomAngle");
        for (var i = 0; i < numberOfSlice; i++) {
          print(
              "Index is $i and angle is ${_calculateCurrentSliceAngle(i) - 360 * 5}");
        }

        _calculateSliceIndexesInRange();
      }),
      body: Container(
        margin: EdgeInsets.only(
            left: widget.screenSize.width * (0.5),
            top: widget.screenSize.height * (0.5)),
        width: heightAndWidth,
        height: heightAndWidth,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ..._buildSlices(),
            Align(
              alignment: Alignment.topLeft,
              child: Transform.translate(
                offset: Offset(-spinArrowSize, -spinArrowSize),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: spinArrowSize,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: -spinArrowSize * (0.5),
                        left: spinArrowSize - 3.0,
                        child: Container(
                          width: 3.0,
                          height: spinArrowSize,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ArcCustomPainter extends CustomPainter {
  final double angle;

  final Color arcColor;

  ArcCustomPainter({required this.angle, required this.arcColor});

  double _angleDegreeToRadian() {
    return (angle * pi) / 180.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double radius = Math.min(size.width, size.height);

    Path path = _buildPath(radius: radius, angle: _angleDegreeToRadian());
    canvas.drawPath(path, Paint()..color = arcColor);

    //canvas.drawArc(Rect.fromCircle(center: Offset(size.width * (0.5), size.height * (0.5)), radius: size.width * 0.5), _initialAngleToRadin(), _degreeToRadian(), true, paint);
  }

  Path _buildPath({required double radius, required double angle}) {
    Path path = Path();

    path
      ..moveTo(0, 0)
      ..lineTo(radius, 0)
      ..arcTo(
        Rect.fromCircle(
          center: Offset(0, 0),
          radius: radius,
        ),
        0,
        angle,
        false,
      )
      ..close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
