import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CurveScreen extends StatelessWidget {
  const CurveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shapes And Curves"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomPaint(
              painter: CubicCurvePainter(),
              child: Container(
                decoration: BoxDecoration(border: Border.all()),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * (0.4),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}

class CubicCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader = ui.Gradient.linear(Offset(size.width * (0.5), 0), Offset(size.width * (0.5), size.height), [Colors.redAccent, Colors.transparent])
      ..strokeWidth = 5.0;
    Path path = Path();

    path.moveTo(0, size.height * (0.15));
    //inorder to give wave like shape use cubic and give two control points with same x axis but different y axis
    path.cubicTo(size.width * (0.3), 0, size.width * (0.3), size.height * (0.2), size.width * (0.5), size.height * (0.2));

    path.cubicTo(size.width * (0.7), size.height * (0.2), size.width * (0.7), 0, size.width, size.height * (0.15));
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
