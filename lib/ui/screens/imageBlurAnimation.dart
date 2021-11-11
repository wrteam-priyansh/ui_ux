import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';

class ImageBlurAnimation extends StatefulWidget {
  ImageBlurAnimation({Key? key}) : super(key: key);

  @override
  _ImageBlurAnimationState createState() => _ImageBlurAnimationState();
}

class _ImageBlurAnimationState extends State<ImageBlurAnimation> with TickerProviderStateMixin {
  late AnimationController animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
  late Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));

  String currentImage = "assets/images/image-3.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () async {
          animationController.forward().then((value) {
            setState(() {
              currentImage = "assets/images/image-2.png";
            });
            animationController.reverse();
          });

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
                opacity: animation.drive(Tween<double>(begin: 1.0, end: 0.6)),
                child: Container(
                  width: 300,
                  height: 300,
                  child: Image.asset(currentImage),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    final double sigmaX = animation.drive(Tween<double>(begin: 0.0, end: 5.0)).value;
                    final double sigmaY = animation.drive(Tween<double>(begin: 0.0, end: 5.0)).value;

                    return ClipRRect(
                      child: BackdropFilter(
                          child: Container(
                            width: 300,
                            height: 300,
                          ),
                          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY)),
                    );
                  }),
            )
          ],
        ));
  }
}
