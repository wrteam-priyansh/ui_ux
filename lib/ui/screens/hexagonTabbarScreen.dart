import 'dart:math';

import 'package:flutter/material.dart';

class HexagonTabbarScreen extends StatefulWidget {
  HexagonTabbarScreen({Key? key}) : super(key: key);

  @override
  _HexagonTabbarScreenState createState() => _HexagonTabbarScreenState();
}

class _HexagonTabbarScreenState extends State<HexagonTabbarScreen> with TickerProviderStateMixin {
  //
  late AnimationController hexagonAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
  late Animation<double> hexagonAnimation = Tween<double>(begin: 0.0, end: 180).animate(CurvedAnimation(parent: hexagonAnimationController, curve: Curves.easeInOut));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (hexagonAnimationController.isCompleted) {
            hexagonAnimationController.reverse();
          } else {
            hexagonAnimationController.forward();
          }
        },
      ),
      body: Center(
        child: AnimatedBuilder(
            animation: hexagonAnimationController,
            builder: (context, _) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateZ((pi / 180) * hexagonAnimation.value),
                child: ClipPath(
                  child: Container(
                    width: 300,
                    height: 300,
                    color: Colors.amber,
                  ),
                  clipper: MyClipper(),
                ),
              );
            }),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width * (0.5), 0);
    path.lineTo(size.width, size.height * (0.25));
    path.lineTo(size.width, (size.height * (0.25)) + sqrt(((size.width * 0.5) * (size.width * 0.5)) + ((size.height * 0.25) * (size.height * 0.25))));
    path.lineTo(size.width * (0.5), size.height);
    path.lineTo(0, size.height * (0.75));
    path.lineTo(0, size.height * (0.25) - sqrt(((size.width * 0.5) * (size.width * 0.5)) + ((size.height * 0.25) * (size.height * 0.25))));

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
