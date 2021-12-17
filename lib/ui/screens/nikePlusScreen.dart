import 'package:flutter/material.dart';

class NikePlusScreen extends StatefulWidget {
  NikePlusScreen({Key? key}) : super(key: key);

  @override
  _NikePlusScreenState createState() => _NikePlusScreenState();
}

class _NikePlusScreenState extends State<NikePlusScreen> with TickerProviderStateMixin {
  late AnimationController animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ));

  late Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {
          if (animationController.isCompleted) {
            animationController.reverse();
          } else {
            animationController.forward();
          }
        }),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  final double scale = animation.drive(Tween<double>(begin: 1.0, end: 0.975)).value;

                  //final double angle = animation.drive(Tween<double>(begin: 0, end: 0.5)).value;
                  final double heightPercentage = animation.drive(Tween<double>(begin: 0.5, end: 0.46)).value;
                  return Positioned(
                    left: MediaQuery.of(context).size.width * (0.1),
                    bottom: 0,
                    child: Container(
                      transformAlignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        //..rotateX((pi / 180) * angle)
                        ..scale(scale),
                      width: MediaQuery.of(context).size.width * (0.8),
                      height: MediaQuery.of(context).size.height * heightPercentage,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  final bottomPercentage = animation.drive(Tween<double>(begin: -0.1, end: 0.2)).value;
                  return Positioned(
                    child: Container(
                      width: MediaQuery.of(context).size.width * (0.8),
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    bottom: MediaQuery.of(context).size.height * (bottomPercentage),
                    left: MediaQuery.of(context).size.width * (0.1),
                  );
                },
              )
            ],
          ),
        ));
  }
}
