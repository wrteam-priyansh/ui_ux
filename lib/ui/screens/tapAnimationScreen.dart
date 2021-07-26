import 'package:flutter/material.dart';

class TapAnimationScreen extends StatefulWidget {
  TapAnimationScreen({Key? key}) : super(key: key);

  @override
  _TapAnimationScreenState createState() => _TapAnimationScreenState();
}

class _TapAnimationScreenState extends State<TapAnimationScreen> with SingleTickerProviderStateMixin {
  final Duration duration = Duration(milliseconds: 75);
  final double endScale = 0.95;

  late AnimationController animationController = AnimationController(vsync: this, duration: duration);
  late Animation<double> animation = Tween<double>(begin: 1.0, end: endScale).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));

  @override
  Widget build(BuildContext context) {
    Widget child = Center(
      child: Container(
        color: Theme.of(context).accentColor,
        height: MediaQuery.of(context).size.height * (0.5),
        width: MediaQuery.of(context).size.width,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Tap Animation")),
      body: GestureDetector(
        onTapCancel: () {
          animationController.reverse();
        },
        onTapDown: (tapDownDetails) {
          animationController.forward();
        },
        onTap: () {
          animationController.reverse();
        },
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.scale(
              scale: animation.value,
              child: child,
            );
          },
          child: child,
        ),
      ),
    );
  }
}
