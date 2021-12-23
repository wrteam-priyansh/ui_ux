import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:math' as Math;

import 'package:flutter_svg/svg.dart';

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

  int numberOfSlice = 12;

  late double randomAngle = Random.secure().nextDouble() * 360;

  late double sliceAngle = 360 / numberOfSlice;

  late double spinArrowSize = 25.0;

  late int selectedIndex = -1;

  @override
  void dispose() {
    spinWheelAnimationController.dispose();
    super.dispose();
  }

  Color _getArcColor(int index) {
    if (selectedIndex == -1) {
      return index.isOdd ? Color(0xffFE1614) : Color(0xffFFFEF9);
    }

    return index == selectedIndex
        ? index.isOdd
            ? Color(0xffFE1614)
            : Color(0xffFFFEF9)
        : Colors.grey.shade200;
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
                padding: EdgeInsets.only(right: 15.0),
                child: Transform.rotate(
                  alignment: Alignment.topLeft,
                  angle: _degreeToRadian(sliceAngle * (0.5)),
                  child: Container(
                    alignment: Alignment.topRight,
                    child: Transform.translate(
                      offset: Offset(0.0, -fontSize * (0.5)),
                      child: Text(
                        "Lucky Fruit $index",
                        style: TextStyle(
                            color: index.isOdd ? Colors.white : Colors.black,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w500,
                            height: 1.0),
                      ),
                    ),
                  ),
                ),
              ),
              painter: ArcCustomPainter(
                angle: sliceAngle,
                arcColor: _getArcColor(index),
              ),
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

  int _calculateSliceIndexeInRange() {
    int selectedIndex = 0;

    for (var i = 0; i < numberOfSlice; i++) {
      var currentAngle = _calculateCurrentSliceAngle(i) - 360 * 5;
      //print("Index is $i and angles is $currentAngle");

      if (currentAngle > 360) {
        //then check for 630
        bool isInRange =
            (currentAngle <= 630 && 630 <= (currentAngle + sliceAngle));
        if (isInRange) {
          selectedIndex = i;
          break;
        }
      } else {
        //then check for 360

        bool isInRange =
            (currentAngle <= 270 && 270 <= (currentAngle + sliceAngle));
        if (isInRange) {
          selectedIndex = i;
          break;
        }
      }
    }

    return selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      floatingActionButton: FloatingActionButton(onPressed: () async {
        await spinWheelAnimationController.forward();

        setState(() {
          selectedIndex = _calculateSliceIndexeInRange();
        });
      }),
      body: Stack(
        children: [
          Container(
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
                      backgroundColor: Colors.transparent,
                      radius: spinArrowSize,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SvgPicture.asset("assets/images/point.svg")
                          // Positioned(
                          //   top: -spinArrowSize * (0.5),
                          //   left: spinArrowSize - 3.0,
                          //   child: Container(
                          //     width: 3.0,
                          //     height: spinArrowSize,
                          //     color: Colors.black,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              child: selectedIndex == -1
                  ? Container()
                  : Text("Lucky fruit $selectedIndex"),
              padding: EdgeInsets.only(top: 150.0),
            ),
          )
        ],
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
