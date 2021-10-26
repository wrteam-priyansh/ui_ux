import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class CurveScreen extends StatefulWidget {
  const CurveScreen({Key? key}) : super(key: key);

  @override
  State<CurveScreen> createState() => _CurveScreenState();
}

class _CurveScreenState extends State<CurveScreen> with TickerProviderStateMixin {
  late AnimationController _animationController = AnimationController(vsync: this, duration: Duration(seconds: 6));
  late Animation<double> _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    parent: _animationController,
    curve: Interval(0.0, 0.2),
  ));

  late Animation<double> _firstCurveAnimation = Tween<double>(begin: 0.0, end: 90.0).animate(CurvedAnimation(
    parent: _animationController,
    curve: Interval(0.2, 0.25),
  ));

  late Animation<double> _secondPointAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    parent: _animationController,
    curve: Interval(0.25, 0.45),
  ));
  late Animation<double> _secondCurveAnimation = Tween<double>(begin: 0.0, end: 90.0).animate(CurvedAnimation(
    parent: _animationController,
    curve: Interval(0.45, 0.5),
  ));
  late Animation<double> _thirdAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    parent: _animationController,
    curve: Interval(0.5, 0.7),
  ));
  late Animation<double> _thirdCurveAnimation = Tween<double>(begin: 0.0, end: 90.0).animate(CurvedAnimation(
    parent: _animationController,
    curve: Interval(0.7, 0.75),
  ));
  late Animation<double> _fourthPointAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    parent: _animationController,
    curve: Interval(0.75, 0.95),
  ));
  late Animation<double> _fourhtCurveAnimation = Tween<double>(begin: 0.0, end: 90.0).animate(CurvedAnimation(
    parent: _animationController,
    curve: Interval(0.95, 1.0),
  ));

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  GlobalKey cubicCurveGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shapes And Curves"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        //
        _animationController.forward(from: 0.0);
      }),
      body: Stack(
        children: [
          /*
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 250),
              child: CustomPaint(
                painter: CubicCurvePainter(context),
                child: GestureDetector(
                  onTapUp: (tapUp) {
                    print("Print up box");
                    //final RenderBox box = cubicCurveGlobalKey.currentContext!.findRenderObject()! as RenderBox;
                    // if (box.hitTest(BoxHitTestResult(), position: tapUp.globalPosition)) {
                    //   print("Tapped outside");
                    // } else {
                    //   print("Tapped inside");
                    // }
                  },
                  onTap: () {
                    //final RenderBox box = cubicCurveGlobalKey.currentContext!.findRenderObject()! as RenderBox;
                    //print(box.size);
                  },
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.yellow)),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * (0.4),
                  ),
                ),
              ),
            ),
          ),
          */

          Center(
            child: CustomPaint(
              key: cubicCurveGlobalKey,
              painter: CubicCurvePainter(context),
              child: GestureDetector(
                onTapUp: (tapUp) {
                  final RenderBox box = cubicCurveGlobalKey.currentContext!.findRenderObject()! as RenderBox;
                  if (box.hitTest(BoxHitTestResult(), position: tapUp.globalPosition)) {
                    print("Tapped outside");
                  } else {
                    print("Tapped inside");
                  }
                },
                onTap: () {
                  //final RenderBox box = cubicCurveGlobalKey.currentContext!.findRenderObject()! as RenderBox;
                  //print(box.size);
                },
                child: Container(
                  decoration: BoxDecoration(border: Border.all()),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * (0.4),
                ),
              ),
            ),
          ),

          // SizedBox(
          //   height: 50.0,
          // ),
          /*
          Align(
            alignment: Alignment.center,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    width: 300,
                    height: 300,
                  ),
                  painter: RectanglePainter(
                      color: Colors.orange,
                      paintingStyle: PaintingStyle.stroke,
                      points: [
                        _animation.value,
                        _firstCurveAnimation.value,
                        _secondPointAnimation.value,
                        _secondCurveAnimation.value,
                        _thirdAnimation.value,
                        _thirdCurveAnimation.value,
                        _fourthPointAnimation.value,
                        _fourhtCurveAnimation.value,
                      ],
                      animationControllerValue: _animationController.value,
                      curveRadius: 30),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CustomPaint(
              child: Container(
                width: 300,
                height: 300,
              ),
              painter: RectanglePainter(
                  color: Colors.redAccent.shade200,
                  paintingStyle: PaintingStyle.fill,
                  points: [
                    _animation.value,
                    _firstCurveAnimation.value,
                    _secondPointAnimation.value,
                    _secondCurveAnimation.value,
                    _thirdAnimation.value,
                    _thirdCurveAnimation.value,
                    _fourthPointAnimation.value,
                    _fourhtCurveAnimation.value,
                  ],
                  animationControllerValue: _animationController.value,
                  curveRadius: 30),
            ),
          ),
          */
        ],
      ),
    );
  }
}

class RectanglePainter extends CustomPainter {
  final PaintingStyle paintingStyle;
  final Color color;
  final List<double> points;
  final double animationControllerValue;
  final double curveRadius;
  RectanglePainter({required this.color, required this.points, required this.animationControllerValue, required this.curveRadius, required this.paintingStyle});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = paintingStyle
      //..shader = ui.Gradient.linear(Offset(size.width * (0.5), 0), Offset(size.width * (0.5), size.height), [Colors.redAccent, Colors.transparent])
      ..strokeWidth = 10.0;

    Path path = Path();

    path.moveTo(curveRadius, 0);

    if (paintingStyle == PaintingStyle.stroke) {
      if (animationControllerValue <= 0.2) {
        //add animation here
        //if ((size.width - curveRadius) * points.first > curveRadius) {
        path.lineTo(curveRadius + size.width * points.first - (2 * curveRadius * points.first), 0);
      } else if (animationControllerValue > 0.2 && animationControllerValue <= 0.25) {
        //
        path.lineTo(size.width - curveRadius, 0);

        path.addArc(Rect.fromCircle(center: Offset(size.width - curveRadius, curveRadius), radius: curveRadius), 3 * pi / 2, (pi / 180) * points[1]);
        //
      } else if (animationControllerValue > 0.25 && animationControllerValue <= 0.45) {
        //add animation here
        path.lineTo((size.width - curveRadius) * points.first, 0);
        path.addArc(Rect.fromCircle(center: Offset(size.width - curveRadius, curveRadius), radius: curveRadius), 3 * pi / 2, pi / 2);
        //second line
        //if ((size.height - curveRadius) * points[2] > curveRadius) {
        path.lineTo(size.width, curveRadius + (size.height * points[2]) - (2 * curveRadius * points[2]));
        //}
      } else if (animationControllerValue > 0.45 && animationControllerValue <= 0.5) {
        path.lineTo((size.width - curveRadius) * points.first, 0);
        path.addArc(Rect.fromCircle(center: Offset(size.width - curveRadius, curveRadius), radius: curveRadius), 3 * pi / 2, (pi / 180) * points[1]);
        path.lineTo(size.width, (size.height - curveRadius) * points[2]);
        //second curve
        path.addArc(Rect.fromCircle(center: Offset(size.width - curveRadius, size.height - curveRadius), radius: curveRadius), 0, (pi / 180) * points[3]);
      } else if (animationControllerValue > 0.5 && animationControllerValue <= 0.7) {
        path.lineTo((size.width - curveRadius) * points.first, 0);
        path.addArc(Rect.fromCircle(center: Offset(size.width - curveRadius, curveRadius), radius: curveRadius), 3 * pi / 2, (pi / 180) * points[1]);
        path.lineTo(size.width, (size.height - curveRadius) * points[2]);
        path.addArc(Rect.fromCircle(center: Offset(size.width - curveRadius, size.height - curveRadius), radius: curveRadius), 0, (pi / 180) * points[3]);
        //third line

        path.lineTo(size.width - curveRadius - (size.width) * points[4] + 2 * (curveRadius) * points[4], size.height);
      } else if (animationControllerValue > 0.7 && animationControllerValue <= 0.75) {
        path.lineTo((size.width - curveRadius) * points.first, 0);
        path.addArc(Rect.fromCircle(center: Offset(size.width - curveRadius, curveRadius), radius: curveRadius), 3 * pi / 2, (pi / 180) * points[1]);

        path.lineTo(size.width, (size.height - curveRadius) * points[2]);

        path.addArc(Rect.fromCircle(center: Offset(size.width - curveRadius, size.height - curveRadius), radius: curveRadius), 0, pi / 2);

        path.lineTo(curveRadius, size.height);

        //third curve
        path.addArc(Rect.fromCircle(center: Offset(curveRadius, size.height - curveRadius), radius: curveRadius), pi / 2, (pi / 180) * points[5]);
      } else if (animationControllerValue > 0.75 && animationControllerValue <= 0.95) {
        path.lineTo((size.width - curveRadius) * points.first, 0);
        path.addArc(Rect.fromCircle(center: Offset(size.width - curveRadius, curveRadius), radius: curveRadius), 3 * pi / 2, (pi / 180) * points[1]);
        path.lineTo(size.width, (size.height - curveRadius) * points[2]);
        path.addArc(Rect.fromCircle(center: Offset(size.width - curveRadius, size.height - curveRadius), radius: curveRadius), 0, pi / 2);
        path.lineTo(curveRadius, size.height);
        path.addArc(Rect.fromCircle(center: Offset(curveRadius, size.height - curveRadius), radius: curveRadius), pi / 2, pi / 2);
        //fourth line

        path.lineTo(0, size.height - curveRadius + (2 * curveRadius * points[6]) - (size.height * points[6])); //points[6]
      } else if (animationControllerValue > 0.95 && animationControllerValue <= 1.0) {
        path.lineTo((size.width - curveRadius) * points.first, 0);
        path.addArc(Rect.fromCircle(center: Offset(size.width - curveRadius, curveRadius), radius: curveRadius), 3 * pi / 2, (pi / 180) * points[1]);
        path.lineTo(size.width, (size.height - curveRadius) * points[2]);
        path.addArc(Rect.fromCircle(center: Offset(size.width - curveRadius, size.height - curveRadius), radius: curveRadius), 0, pi / 2);
        path.lineTo(curveRadius, size.height);
        path.addArc(Rect.fromCircle(center: Offset(curveRadius, size.height - curveRadius), radius: curveRadius), pi / 2, pi / 2);
        path.lineTo(0, curveRadius);
        path.addArc(Rect.fromCircle(center: Offset(curveRadius, curveRadius), radius: curveRadius), pi, (pi / 180) * points[7]);
      }

      canvas.drawPath(path, paint);
    } else {
      canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(curveRadius)), paint);
      //
      /*
      path.lineTo((size.width - curveRadius), 0);
      path.addArc(Rect.fromCircle(center: Offset(size.width - curveRadius, curveRadius), radius: curveRadius), 3 * pi / 2, pi / 2);
      path.lineTo(size.width, (size.height - curveRadius));
      path.addArc(Rect.fromCircle(center: Offset(size.width - curveRadius, size.height - curveRadius), radius: curveRadius), 0, pi / 2);
      path.lineTo(curveRadius, size.height);
      path.addArc(Rect.fromCircle(center: Offset(curveRadius, size.height - curveRadius), radius: curveRadius), pi / 2, pi / 2);
      path.lineTo(0, curveRadius);
      path.addArc(Rect.fromCircle(center: Offset(curveRadius, curveRadius), radius: curveRadius), pi, pi / 2);
    */

    }

/*
    if (animationControllerValue <= 0.25) {
      path.lineTo(size.width * points.first, 0);
    } else if (animationControllerValue > 0.25 && animationControllerValue <= 0.5) {
      path.lineTo(size.width * points.first, 0);
      path.lineTo(size.width * points.first, size.height * points[1]);
    } else if (animationControllerValue > 0.5 && animationControllerValue <= 0.75) {
      path.lineTo(size.width * points.first, 0);
      path.lineTo(size.width * points.first, size.height * points[1]);
      path.lineTo(size.width * points[2], size.height * points[1]);
    } else if (animationControllerValue > 0.75 && animationControllerValue < 1.0) {
      path.lineTo(size.width * points.first, 0);
      path.lineTo(size.width * points.first, size.height * points[1]);
      path.lineTo(size.width * points[2], size.height * points[1]);
      path.lineTo(size.width * points[2], size.height * points[3]);
    } else {
      path.lineTo(size.width * points.first, 0);
      path.lineTo(size.width * points.first, size.height * points[1]);
      path.lineTo(size.width * points[2], size.height * points[1]);
      path.close();
    }
    */
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CubicCurvePainter extends CustomPainter {
  final BuildContext context;

  late Path path;

  CubicCurvePainter(this.context) {
    path = Path();
  }
  @override
  void paint(Canvas canvas, Size size) {
    //final touchCanvas = TouchyCanvas(context, canvas);
    Paint paint = Paint()
      ..shader = ui.Gradient.linear(Offset(size.width * (0.5), 0), Offset(size.width * (0.5), size.height), [Colors.redAccent, Colors.transparent])
      ..strokeWidth = 5.0;

    path.moveTo(0, size.height * (0.15));
    //inorder to give wave like shape use cubic and give two control points with same x axis but different y axis
    path.cubicTo(size.width * (0.3), 0, size.width * (0.3), size.height * (0.2), size.width * (0.5), size.height * (0.2));

    path.cubicTo(size.width * (0.7), size.height * (0.2), size.width * (0.7), 0, size.width, size.height * (0.15));
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
    // touchCanvas.drawPath(
    //   path,
    //   paint,
    //   hitTestBehavior: HitTestBehavior.opaque,
    //   onTapUp: (tapUp) {
    //     print("Tap event");

    //     path.contains(tapUp.localPosition);
    //   },
    // );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    //print(position);
    return path.contains(position);
  }
}
