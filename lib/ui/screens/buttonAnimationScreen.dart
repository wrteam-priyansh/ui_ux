import 'package:flutter/material.dart';

class ButtonAnimationScreen extends StatefulWidget {
  ButtonAnimationScreen({Key? key}) : super(key: key);

  @override
  _ButtonAnimationScreenState createState() => _ButtonAnimationScreenState();
}

class _ButtonAnimationScreenState extends State<ButtonAnimationScreen> with TickerProviderStateMixin {
  late AnimationController animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 4000));
  late AnimationController secondAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 4000));

  late Animation<double> firstContainerScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
  late Animation<double> firstContainerFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: animationController, curve: Interval(0.7, 1.0, curve: Curves.easeInOut)));

  late Animation<double> secondContainerScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: secondAnimationController, curve: Curves.easeInOut));
  late Animation<double> secondContainerFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: secondAnimationController, curve: Interval(0.7, 1.0, curve: Curves.easeInOut)));

  @override
  void dispose() {
    animationController.dispose();
    secondAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        animationController.repeat(reverse: false);
        await Future.delayed(Duration(milliseconds: 2500));
        secondAnimationController.repeat(reverse: false);
        //delay of 2800 seconds
      }),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.purpleAccent.shade200, Colors.purple.shade200],
            )),
          ),
          Align(
            alignment: Alignment.center,
            child: FadeTransition(
              opacity: firstContainerFadeAnimation,
              child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    final double scaleX = firstContainerScaleAnimation.drive<double>(Tween(begin: 1.0, end: 1.5)).value;
                    final double scaleY = firstContainerScaleAnimation.drive<double>(Tween(begin: 1.0, end: 1.8)).value;
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(0, 0, scaleX)
                        ..setEntry(1, 1, scaleY),
                      child: Container(
                        width: 200,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: FadeTransition(
              opacity: secondContainerFadeAnimation,
              child: AnimatedBuilder(
                  animation: secondAnimationController,
                  builder: (context, child) {
                    final double scaleX = secondContainerScaleAnimation.drive<double>(Tween(begin: 1.0, end: 1.5)).value;
                    final double scaleY = secondContainerScaleAnimation.drive<double>(Tween(begin: 1.0, end: 1.8)).value;
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(0, 0, scaleX)
                        ..setEntry(1, 1, scaleY),
                      child: Container(
                        width: 200,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 200,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
