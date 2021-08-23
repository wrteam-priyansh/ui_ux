import 'package:flutter/material.dart';

class HeartAnimationScreen extends StatefulWidget {
  HeartAnimationScreen({Key? key}) : super(key: key);

  @override
  _HeartAnimationScreenState createState() => _HeartAnimationScreenState();
}

class _HeartAnimationScreenState extends State<HeartAnimationScreen> with TickerProviderStateMixin {
  late AnimationController animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));

  late Animation<double> scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Interval(0.0, 0.3, curve: Curves.easeInQuad)));

  late Animation<double> heartSizeAnimation = Tween<double>(begin: 20, end: 40).animate(CurvedAnimation(parent: animationController, curve: Interval(0.3, 0.6, curve: Curves.easeInOut)));

  late Animation<double> heartFirstAlignment = Tween<double>(begin: -1.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Interval(0.3, 0.6, curve: Curves.easeInOut)));

  late Animation<double> heartSecondAlignment = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Interval(0.6, 0.9, curve: Curves.ease)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          animationController.forward();
        },
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: scaleAnimation.value,
              child: CircleAvatar(
                child: Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
                  child: Align(
                    alignment: Alignment(0.0, heartFirstAlignment.value - heartSecondAlignment.value),
                    child: Text(
                      '\u2764',
                      style: TextStyle(
                        fontSize: heartSizeAnimation.value,
                      ),
                    ),
                  ),
                ),
                radius: 80.0,
                backgroundColor: Colors.yellow.shade200,
              ),
            );
          },
        ),
      ),
    );
  }
}
