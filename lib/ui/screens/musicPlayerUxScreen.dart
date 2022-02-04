import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ui_ux/convertNumber.dart';

//Left to right scroll means scroll direction is forward

//Right to left scroll means scroll direction is reverse

class MusicPlayerUxScreen extends StatefulWidget {
  MusicPlayerUxScreen({Key? key}) : super(key: key);

  @override
  State<MusicPlayerUxScreen> createState() => _MusicPlayerUxScreenState();
}

class _MusicPlayerUxScreenState extends State<MusicPlayerUxScreen>
    with TickerProviderStateMixin {
  final _pageViewHeightPercentage = 0.58;

  double _currentPage = 0.0;

  bool musicPlayerSelected = false;

  late AnimationController selectedDragCardAnimationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500));

  late Animation<double> topPageViewPaddingAnimation =
      Tween<double>(begin: 0.0, end: 0.1).animate(CurvedAnimation(
          parent: selectedDragCardAnimationController,
          curve: Curves.easeInOutExpo));

  late AnimationController musicPlayerAnimationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 1000));

  late Animation<double> songImageHeightDownAnimation =
      Tween<double>(begin: 0.4, end: 0.3).animate(CurvedAnimation(
          parent: musicPlayerAnimationController,
          curve: Interval(0.0, 0.65, curve: Curves.easeInOut)));

  late Animation<double> songImageHeightUpAnimation =
      Tween<double>(begin: 0.0, end: 0.175).animate(CurvedAnimation(
          parent: musicPlayerAnimationController,
          curve: Interval(0.65, 1.0, curve: Curves.easeInOut)));

  //TODO : Need to use different animation controller for managing content of music player second page

  late PageController _pageController = PageController(
    viewportFraction: 0.75, //0.125
  )..addListener(pageControllerListener);

  void pageControllerListener() {
    //
    setState(() {
      _currentPage = _pageController.page!;
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(pageControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F2E7),
      appBar: AppBar(),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedBuilder(
              animation: selectedDragCardAnimationController,
              builder: (context, child) {
                return Padding(
                  child: child,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height *
                        (0.1 + topPageViewPaddingAnimation.value),
                  ),
                );
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height *
                    _pageViewHeightPercentage,
                child: PageView.builder(
                    clipBehavior: Clip.none,
                    controller: _pageController,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      double pageOffset = 1.0 * (index) - _currentPage;
                      double scale = 1.0;
                      double bottomMarginPercentage = 0.0;
                      double dragToListenTopMarginPercentage = 0.0;
                      double dragToListenOpacity = 1.0;

                      if (pageOffset >= 0) {
                        //
                        scale = ConvertNumber.inRange(
                            currentValue: pageOffset,
                            minValue: 0.0,
                            maxValue: 1.0,
                            newMaxValue: 1.5,
                            newMinValue: 1.0);

                        bottomMarginPercentage = ConvertNumber.inRange(
                            currentValue: pageOffset,
                            minValue: 0.0,
                            maxValue: 1.0,
                            newMaxValue: 0.15,
                            newMinValue: 0.0);
                      } else {
                        //
                        scale = ConvertNumber.inRange(
                            currentValue: pageOffset,
                            minValue: 0.0,
                            maxValue: -1.0,
                            newMaxValue: 1.5,
                            newMinValue: 1.0);

                        bottomMarginPercentage = ConvertNumber.inRange(
                            currentValue: pageOffset,
                            minValue: 0.0,
                            maxValue: -1.0,
                            newMaxValue: 0.15,
                            newMinValue: 0.0);

                        //

                      }

                      if (bottomMarginPercentage <= 0.065) {
                        dragToListenTopMarginPercentage = ConvertNumber.inRange(
                            currentValue: bottomMarginPercentage,
                            minValue: 0.0,
                            maxValue: 0.065,
                            newMaxValue: 0.0,
                            newMinValue: 0.075);

                        dragToListenOpacity = ConvertNumber.inRange(
                            currentValue: bottomMarginPercentage,
                            minValue: 0.0,
                            maxValue: 0.065,
                            newMaxValue: 0.0,
                            newMinValue: 1.0);
                      }

                      return LayoutBuilder(builder: (context, boxConstraints) {
                        return GestureDetector(
                          onVerticalDragEnd: (_) async {
                            if (pageOffset == 0) {
                              await selectedDragCardAnimationController
                                  .forward();
                              setState(() {
                                musicPlayerSelected = true;
                              });
                              musicPlayerAnimationController.forward();
                            }
                          },
                          onVerticalDragUpdate: (dragUpdateDetails) {
                            if (pageOffset == 0) {
                              double dragged = dragUpdateDetails.primaryDelta! /
                                  MediaQuery.of(context).size.height;

                              selectedDragCardAnimationController.value =
                                  selectedDragCardAnimationController.value +
                                      3.0 * dragged;
                            }
                          },
                          child: Container(
                            padding: EdgeInsetsDirectional.all(20.0),
                            margin: EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                                bottom: boxConstraints.maxHeight *
                                    (bottomMarginPercentage)),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 40.0),
                                    blurRadius: 45.0,
                                    spreadRadius: 20.0,
                                    color: Colors.black12,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: boxConstraints.maxHeight * (0.5),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Transform.scale(
                                        scale: scale,
                                        child: Image.asset(
                                          "assets/images/woman_a.jpg",
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                ),
                                //available 0.85 space

                                SizedBox(
                                  height: boxConstraints.maxHeight * (0.035),
                                ),

                                Text(
                                  "Pyaar ke pal",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                SizedBox(
                                  height: boxConstraints.maxHeight * (0.02),
                                ),
                                Text(
                                  "Album/Movie name",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),

                                SizedBox(
                                  height: boxConstraints.maxHeight * (0.015),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.teal,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.teal,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.teal,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.teal,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.teal,
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: boxConstraints.maxHeight *
                                      (dragToListenTopMarginPercentage),
                                ),

                                bottomMarginPercentage >= 0.065
                                    ? SizedBox()
                                    : Opacity(
                                        opacity: dragToListenOpacity,
                                        child: Column(
                                          children: [
                                            Text(
                                              "Drag to listen",
                                              style: TextStyle(fontSize: 18.0),
                                            ),
                                            SizedBox(
                                              height: boxConstraints.maxHeight *
                                                  (0.0125),
                                            ),
                                            Transform.rotate(
                                              angle: (pi / 180) * 270,
                                              child: Icon(
                                                Icons.arrow_back_ios,
                                                size: 18.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        );
                      });
                    }),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            //first animation controller to increase height and width of this container
            child: AnimatedBuilder(
              animation: musicPlayerAnimationController,
              builder: (context, child) {
                return AnimatedBuilder(
                  animation: selectedDragCardAnimationController,
                  builder: (context, child) {
                    final menuOpendedPadding =
                        Tween<double>(begin: 0.0, end: 0.2)
                            .animate(CurvedAnimation(
                                parent: musicPlayerAnimationController,
                                curve: Curves.easeInOutExpo))
                            .value;
                    //

                    final topPaddingPercentage = (0.1 +
                            0.1 * selectedDragCardAnimationController.value) -
                        menuOpendedPadding;

                    final horizontalPaddingPercentage =
                        Tween<double>(begin: 1.0, end: 0.0)
                            .animate(CurvedAnimation(
                                parent: musicPlayerAnimationController,
                                curve: Curves.easeInOutExpo))
                            .value;
                    return Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width *
                            (0.125) *
                            horizontalPaddingPercentage,
                        right: MediaQuery.of(context).size.width *
                            (0.125) *
                            horizontalPaddingPercentage,
                        top: MediaQuery.of(context).size.height *
                            topPaddingPercentage,
                      ),
                      child: IgnorePointer(
                        ignoring: !musicPlayerSelected,
                        child: Opacity(
                          opacity: musicPlayerSelected ? 1.0 : 0.0,
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height *
                                (_pageViewHeightPercentage +
                                    ((1.0 - _pageViewHeightPercentage) *
                                        musicPlayerAnimationController.value)),
                            child: LayoutBuilder(
                                builder: (context, boxConstraints) {
                              //image height of current song

                              final currentSongImageHeight =
                                  songImageHeightDownAnimation.value +
                                      songImageHeightUpAnimation.value;

                              return SingleChildScrollView(
                                child: Column(children: [
                                  //top padding
                                  SizedBox(
                                    height: boxConstraints.maxHeight * (0.05),
                                  ),

                                  //current song image
                                  SizedBox(
                                    height: boxConstraints.maxHeight *
                                        (currentSongImageHeight),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.asset(
                                          "assets/images/woman_a.jpg",
                                          fit: BoxFit.cover,
                                        )),
                                  ),

                                  FadeTransition(
                                    opacity: Tween<double>(begin: 0.0, end: 1.0)
                                        .animate(
                                      CurvedAnimation(
                                        parent: musicPlayerAnimationController,
                                        curve: Interval(0.4, 1.0,
                                            curve: Curves.easeInOut),
                                      ),
                                    ),
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                              begin: Offset(0.0, 8.0),
                                              end: Offset.zero)
                                          .animate(
                                        CurvedAnimation(
                                          parent:
                                              musicPlayerAnimationController,
                                          curve: Interval(0.4, 1.0,
                                              curve: Curves.easeInOut),
                                        ),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(top: 20.0),
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                (0.1)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Pal 1999",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "Pyaar ke pal by K.K.",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              );
                            }),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )

          //
        ],
      ),
    );
  }
}
