import 'package:flutter/material.dart';

class HotelRoomAnimation extends StatefulWidget {
  HotelRoomAnimation({Key? key}) : super(key: key);

  @override
  _HotelRoomAnimationState createState() => _HotelRoomAnimationState();
}

class _HotelRoomAnimationState extends State<HotelRoomAnimation> with TickerProviderStateMixin {
  late AnimationController menuAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
  late Animation<double> menuAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: menuAnimationController, curve: Curves.easeInOut));

  late AnimationController openContainerAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 1));

  late Animation<double> openContainerSizeDownAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: openContainerAnimationController,
      curve: Interval(
        0.0,
        0.3,
        curve: Curves.easeInOut,
      )));
  late Animation<double> openContainerSizeUpAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: openContainerAnimationController,
      curve: Interval(
        0.3,
        1.0,
        curve: Curves.easeInOut,
      )));

  late AnimationController roomControlAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  late Animation<double> roomControlAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: roomControlAnimationController, curve: Curves.easeInOut));
  late AnimationController roomControlScrollAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));

  late Animation<double> topRoomControlScrollAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: roomControlScrollAnimationController, curve: Interval(0.0, 1.0, curve: Curves.easeInOutCubic)));
  late Animation<double> secondRoomControlScrollAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: roomControlScrollAnimationController, curve: Interval(0.2, 1.0, curve: Curves.easeInOutCubic)));
  late Animation<double> thirdRoomControlScrollAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: roomControlScrollAnimationController, curve: Interval(0.3, 1.0, curve: Curves.easeInOutCubic)));

  final double initialHeightPercentage = 0.5;
  final double initialWidthPercentage = 0.75;
  late bool ignoreRoomControls = true;
  final double roomMenuSpacingPercentage = 0.025;

  @override
  void dispose() {
    menuAnimationController.dispose();
    roomControlAnimationController.dispose();
    openContainerAnimationController.dispose();
    roomControlScrollAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: openContainerAnimationController,
              builder: (context, child) {
                return AnimatedBuilder(
                  animation: menuAnimationController,
                  builder: (context, child) {
                    if (openContainerAnimationController.isAnimating) {
                      return Container();
                    }
                    final topMarginPercentage = menuAnimation.drive<double>(Tween(begin: 0.0, end: 0.2)).value;
                    final widthPercentage = menuAnimation.drive<double>(Tween(begin: initialWidthPercentage, end: 0.9)).value;
                    final opacity = menuAnimation.drive<double>(Tween(begin: 0.7, end: 1.0)).value;
                    final heightPercentage = menuAnimation.drive<double>(Tween(begin: initialHeightPercentage, end: initialHeightPercentage + 0.1)).value;

                    return Opacity(
                      opacity: opacity,
                      child: Container(
                        color: Colors.pinkAccent,
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * (topMarginPercentage)),
                        width: MediaQuery.of(context).size.width * widthPercentage,
                        height: MediaQuery.of(context).size.height * heightPercentage,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: openContainerAnimationController,
              builder: (context, child) {
                return AnimatedBuilder(
                  animation: menuAnimationController,
                  builder: (context, child) {
                    final bottomMarginPercentage = menuAnimation.drive<double>(Tween(begin: 0.0, end: 0.15)).value;
                    double widthPercentage = openContainerSizeDownAnimation.drive<double>(Tween(begin: initialWidthPercentage, end: initialWidthPercentage - 0.1)).value;
                    widthPercentage = widthPercentage + (1.0 - widthPercentage) * openContainerSizeUpAnimation.value;
                    double heightPercentage = openContainerSizeDownAnimation.drive<double>(Tween(begin: initialHeightPercentage, end: initialHeightPercentage - 0.1)).value;
                    heightPercentage = heightPercentage + (1.0 - heightPercentage) * openContainerSizeUpAnimation.value;

                    return GestureDetector(
                      onTap: () async {
                        if (openContainerAnimationController.isCompleted) {
                          setState(() {
                            ignoreRoomControls = true;
                          });
                          await roomControlAnimationController.reverse();
                          openContainerAnimationController.reverse();
                        } else {
                          await openContainerAnimationController.forward();
                          await roomControlAnimationController.forward();
                          setState(() {
                            ignoreRoomControls = false;
                          });
                        }

                        // if (menuAnimationController.isCompleted) {
                        //   menuAnimationController.reverse();
                        // } else {
                        //   menuAnimationController.forward();
                        // }
                      },
                      child: Container(
                        color: Colors.orangeAccent,
                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * (bottomMarginPercentage)),
                        width: MediaQuery.of(context).size.width * widthPercentage,
                        height: MediaQuery.of(context).size.height * heightPercentage,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: IgnorePointer(
              ignoring: true,
              child: FadeTransition(
                opacity: roomControlAnimation,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * (0.175),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                    Colors.black38,
                    Colors.transparent,
                  ])),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: IgnorePointer(
              ignoring: true,
              child: FadeTransition(
                opacity: roomControlAnimation,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * (0.4),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [
                    Colors.black38,
                    Colors.transparent,
                  ])),
                ),
              ),
            ),
          ),

          //Room menu
          AnimatedBuilder(
            animation: roomControlScrollAnimationController,
            builder: (context, child) {
              return AnimatedBuilder(
                animation: roomControlAnimationController,
                builder: (context, child) {
                  double topPaddingPercentage = roomControlAnimation
                      .drive<double>(Tween(
                        begin: 0.6,
                        end: 0.5,
                      ))
                      .value;
                  topPaddingPercentage = topPaddingPercentage - (0.2) * topRoomControlScrollAnimation.value;
                  return Positioned(
                      top: MediaQuery.of(context).size.height * topPaddingPercentage,
                      child: IgnorePointer(
                        ignoring: ignoreRoomControls,
                        child: Opacity(
                          opacity: roomControlAnimation.value,
                          child: GestureDetector(
                            onTap: () {
                              if (roomControlScrollAnimationController.isCompleted) {
                                roomControlScrollAnimationController.reverse();
                              } else {
                                roomControlScrollAnimationController.forward();
                              }
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * (0.225),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * (0.4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
                },
              );
            },
          ),
          //
          AnimatedBuilder(
            animation: roomControlScrollAnimationController,
            builder: (context, child) {
              return AnimatedBuilder(
                animation: roomControlAnimationController,
                builder: (context, child) {
                  double topPaddingPercentage = roomControlAnimation
                      .drive<double>(Tween(
                        begin: 0.85,
                        end: 0.75,
                      ))
                      .value;
                  topPaddingPercentage = topPaddingPercentage - (0.2) * secondRoomControlScrollAnimation.value;

                  return Positioned(
                      top: MediaQuery.of(context).size.height * topPaddingPercentage,
                      child: IgnorePointer(
                        ignoring: ignoreRoomControls,
                        child: Opacity(
                          opacity: roomControlAnimation.value,
                          child: Container(
                            height: MediaQuery.of(context).size.height * (0.15),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(color: Colors.pinkAccent),
                          ),
                        ),
                      ));
                },
              );
            },
          ),
          //
          AnimatedBuilder(
            animation: roomControlScrollAnimationController,
            builder: (context, child) {
              return AnimatedBuilder(
                animation: roomControlAnimationController,
                builder: (context, child) {
                  double topPaddingPercentage = roomControlAnimation
                      .drive<double>(Tween(
                        begin: 1.025,
                        end: 0.925,
                      ))
                      .value;
                  topPaddingPercentage = topPaddingPercentage - (0.2) * thirdRoomControlScrollAnimation.value;

                  return Positioned(
                      top: MediaQuery.of(context).size.height * topPaddingPercentage,
                      child: IgnorePointer(
                        ignoring: ignoreRoomControls,
                        child: Opacity(
                          opacity: roomControlAnimation.value,
                          child: Container(
                            height: MediaQuery.of(context).size.height * (0.225),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(color: Colors.redAccent),
                          ),
                        ),
                      ));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
