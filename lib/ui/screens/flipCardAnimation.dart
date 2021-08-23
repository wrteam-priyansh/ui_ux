import 'dart:math';

import 'package:flutter/material.dart';

class FlipCardAnimation extends StatefulWidget {
  FlipCardAnimation({Key? key}) : super(key: key);

  @override
  _FlipCardAnimationState createState() => _FlipCardAnimationState();
}

class _FlipCardAnimationState extends State<FlipCardAnimation> with TickerProviderStateMixin {
  late AnimationController flipCardAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));

  late Animation<double> flipCardAnimation = Tween<double>(begin: 0, end: 180).animate(CurvedAnimation(parent: flipCardAnimationController, curve: Curves.easeInOut));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onPressed: () {
          if (flipCardAnimationController.isCompleted) {
            flipCardAnimationController.reverse();
          } else {
            flipCardAnimationController.forward();
          }
        },
      ),
      backgroundColor: Theme.of(context).accentColor,
      body: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: flipCardAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: flipCardAnimation.value < 90 ? 0.0 : 1.0,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY((pi / 180) * (180 - flipCardAnimation.value)),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * (0.3),
                      child: Card(
                        child: Center(
                          child: CircleAvatar(
                            radius: 80,
                            child: Text("Mota Bhai"),
                          ),
                        ),
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: flipCardAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: flipCardAnimation.value > 90 ? 0.0 : 1.0,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY((pi / 180) * (flipCardAnimation.value)),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * (0.3),
                      child: Card(
                        child: Center(
                          child: CircleAvatar(
                            radius: 50,
                            child: Text("Lemon\nchusle"),
                          ),
                        ),
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          //
        ],
      ),
    );
  }
}
