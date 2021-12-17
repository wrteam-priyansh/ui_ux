import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shapes/flutter_shapes.dart';

class ShapesScreen extends StatelessWidget {
  const ShapesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          painter: MyPainter(),
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(border: Border.all()),
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.black;
    final Path path = Path();
    path.moveTo(size.width * (0.5), size.height * (0.5));
    for (int i = 0; i < 360; i++) {
      final double radian = radians(0 + 360 / 360 * i.toDouble());
      final double x = 100 * cos(radian);
      final double y = 100 * sin(radian);

      // print("I is $i and angle is ${360 / 360 * i.toDouble()}");
      // print("Value of x and y is ($x,$y)");
      // print("-----------------------");
      if (i == 0) {
        path.lineTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
