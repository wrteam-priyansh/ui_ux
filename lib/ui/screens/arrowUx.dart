import 'dart:math';

import 'package:flutter/material.dart';

class ArrowUxScreen extends StatefulWidget {
  ArrowUxScreen({Key? key}) : super(key: key);

  @override
  _ArrowUxScreenState createState() => _ArrowUxScreenState();
}

class _ArrowUxScreenState extends State<ArrowUxScreen> with TickerProviderStateMixin {
  late AnimationController arrowAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

  late Animation<Offset> arrowAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(1.5, 0)).animate(CurvedAnimation(parent: arrowAnimationController, curve: Curves.easeInOut));

  late AnimationController colorAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 100));

  late Animation<Color?> colorAnimation = ColorTween(
    begin: Colors.blueAccent,
    end: Colors.redAccent,
  ).animate(CurvedAnimation(parent: colorAnimationController, curve: Curves.easeInOut));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        arrowAnimationController.forward().then((value) => colorAnimationController.forward());
      }),
      body: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Transform(
              transform: Matrix4.identity()
                ..rotateY(pi / 4)
                ..setEntry(0, 3, 25.0),
              child: AnimatedBuilder(
                animation: colorAnimationController,
                builder: (context, child) {
                  return CircleAvatar(
                    radius: 60.0,
                    backgroundColor: colorAnimation.value,
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: SlideTransition(
              position: arrowAnimation,
              child: CustomPaint(
                painter: ArrowPainter(),
                child: Container(
                  height: 5,
                  width: MediaQuery.of(context).size.width * (0.35),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    Path path = Path();

    path.lineTo(size.width * (0.85), 0);
    path.lineTo(size.width * (0.85), -size.height * (3));
    path.lineTo(size.width, 0);
    path.lineTo(size.width * (0.85), size.height * (3));

    path.lineTo(size.width * (0.85), 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
