import 'dart:math';

import 'package:flutter/material.dart';

class NoiseScreen extends StatefulWidget {
  NoiseScreen({Key? key}) : super(key: key);

  @override
  _NoiseScreenState createState() => _NoiseScreenState();
}

class _NoiseScreenState extends State<NoiseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CustomPaint(
        foregroundPainter: NoiseCustomPainter(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
      ),
    );
  }
}

class NoiseCustomPainter extends CustomPainter {
  final Color color;
  final double blocSize;
  final double spacing;

  NoiseCustomPainter({this.color = Colors.red, this.blocSize = 50.0}) : this.spacing = 10;

  @override
  void paint(Canvas canvas, Size size) {
    Random random = Random();
    Paint paint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 5; i++) {
      paint..color = color.withAlpha(random.nextInt(150));

      canvas.drawRect(Rect.fromLTWH((i * blocSize) + spacing * i, 0, blocSize, blocSize), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
