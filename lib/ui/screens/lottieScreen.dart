import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieScreen extends StatefulWidget {
  LottieScreen({Key? key}) : super(key: key);

  @override
  _LottieScreenState createState() => _LottieScreenState();
}

class _LottieScreenState extends State<LottieScreen> with TickerProviderStateMixin {
  String jsonName = "testClock.json";

  late AnimationController animationController = AnimationController(vsync: this);
  late AnimationController clockAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
  late Animation<double> clockScaleUpAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(CurvedAnimation(parent: clockAnimationController, curve: Interval(0.0, 0.4, curve: Curves.easeInOut)));
  late Animation<double> clockScaleDownAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: clockAnimationController, curve: Interval(0.4, 1.0, curve: Curves.easeInOut)));

  late AnimationController logoAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
  late Animation<double> logoScaleUpAnimation = Tween<double>(begin: 0.0, end: 1.1).animate(CurvedAnimation(parent: logoAnimationController, curve: Interval(0.0, 0.4, curve: Curves.easeInOut)));
  late Animation<double> logoScaleDownAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(CurvedAnimation(parent: logoAnimationController, curve: Interval(0.4, 1.0, curve: Curves.easeInOut)));

  @override
  void dispose() {
    animationController.dispose();
    clockAnimationController.dispose();
    logoAnimationController.dispose();
    super.dispose();
  }

  void startAnimation() async {
    await animationController.forward();
    await clockAnimationController.forward();
    await logoAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: clockAnimationController,
              builder: (context, child) {
                double scale = 0.9 + clockScaleUpAnimation.value - clockScaleDownAnimation.value;
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Lottie.asset("assets/animations/$jsonName", controller: animationController, onLoaded: (composition) {
                animationController..duration = composition.duration;
                startAnimation();
              }),
            ),
          ),
          AnimatedBuilder(
              animation: logoAnimationController,
              builder: (context, child) {
                double scale = 0.0 + logoScaleUpAnimation.value - logoScaleDownAnimation.value;
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Center(child: Image.asset("assets/images/logo.png"))),
        ],
      ),
    );
  }
}
