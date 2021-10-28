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

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Center(
            child: Lottie.asset("assets/animations/$jsonName", controller: animationController, onLoaded: (composition) {
              animationController..duration = composition.duration;
              animationController.forward();
            }),
          ),
        ],
      ),
    );
  }
}
