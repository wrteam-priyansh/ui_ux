import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ui_ux/convertNumber.dart';
import 'package:ui_ux/ui/screens/musicPlayerUx/widgets/circularButtonContainer.dart';

//Left to right scroll means scroll direction is forward

//Right to left scroll means scroll direction is reverse

const String dummyText = """ 

It is a long established fact that a reader will be distracted by the
readable content of a page when looking at its layout. The point of using
Lorem Ipsum is that it has a more-or-less normal distribution of letters, 
as opposed to using 'Content here, content here', making it look like readable English.
Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model
text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over
the years, sometimes by accident, sometimes on purpose (injected humour and the like).
""";

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
      AnimationController(vsync: this, duration: Duration(milliseconds: 800));

  late Animation<double> songImageHeightDownAnimation =
      Tween<double>(begin: 0.4, end: 0.3).animate(CurvedAnimation(
          parent: musicPlayerAnimationController,
          curve: Interval(0.0, 0.65, curve: Curves.easeInOut)));

  late Animation<double> songImageHeightUpAnimation =
      Tween<double>(begin: 0.0, end: 0.175).animate(CurvedAnimation(
          parent: musicPlayerAnimationController,
          curve: Interval(0.65, 1.0, curve: Curves.easeInOut)));

  late AnimationController currentTrackContentAnimationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 800));

  late AnimationController albumDetailsAnimationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 600));

  late AnimationController albumDetailsContentAnimationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 600));

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
    currentTrackContentAnimationController.dispose();
    musicPlayerAnimationController.dispose();
    selectedDragCardAnimationController.dispose();
    albumDetailsAnimationController.dispose();
    albumDetailsContentAnimationController.dispose();
    _pageController.removeListener(pageControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F2E7),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              if (musicPlayerSelected) {
                if (albumDetailsAnimationController.isCompleted) {
                  albumDetailsContentAnimationController.reverse();
                  await Future.delayed(Duration(milliseconds: 300));
                  albumDetailsAnimationController.reverse();
                  return;
                }
                //start reverse animation
                currentTrackContentAnimationController.reverse();
                await Future.delayed(Duration(milliseconds: 500));
                await musicPlayerAnimationController.reverse();
                setState(() {
                  musicPlayerSelected = false;
                });
                await selectedDragCardAnimationController.reverse();
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
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

                      if (bottomMarginPercentage <= 0.055) {
                        dragToListenTopMarginPercentage = ConvertNumber.inRange(
                            currentValue: bottomMarginPercentage,
                            minValue: 0.0,
                            maxValue: 0.055,
                            newMaxValue: 0.0,
                            newMinValue: 0.05);

                        dragToListenOpacity = ConvertNumber.inRange(
                            currentValue: bottomMarginPercentage,
                            minValue: 0.0,
                            maxValue: 0.055,
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
                              await Future.delayed(Duration(milliseconds: 375));
                              currentTrackContentAnimationController.forward();
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
                                  height: boxConstraints.maxHeight * (0.0175),
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
                                  height: boxConstraints.maxHeight * (0.0125),
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

                                bottomMarginPercentage >= 0.055
                                    ? SizedBox()
                                    : Flexible(
                                        child: Opacity(
                                          opacity: dragToListenOpacity,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Drag to listen",
                                                style:
                                                    TextStyle(fontSize: 18.0),
                                              ),
                                              SizedBox(
                                                height:
                                                    boxConstraints.maxHeight *
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
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0 -
                                    1.0 *
                                        musicPlayerAnimationController.value)),
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

                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AnimatedBuilder(
                                        animation:
                                            albumDetailsAnimationController,
                                        builder: (context, child) {
                                          double angle = Tween<double>(
                                                  begin: 0, end: 180)
                                              .animate(CurvedAnimation(
                                                  parent:
                                                      albumDetailsAnimationController,
                                                  curve: Curves.easeInOutQuad))
                                              .value;

                                          return Transform(
                                            alignment: Alignment.center,
                                            transform: Matrix4.identity()
                                              ..rotateY(
                                                  (pi / 180) * (180 - angle)),
                                            child: Opacity(
                                              opacity: angle < 90 ? 0.0 : 1.0,
                                              child: Container(
                                                clipBehavior: Clip.none,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    FadeTransition(
                                                      opacity: Tween<double>(
                                                              begin: 0.0,
                                                              end: 1.0)
                                                          .animate(
                                                        CurvedAnimation(
                                                          parent:
                                                              albumDetailsContentAnimationController,
                                                          curve: Curves
                                                              .easeInOutQuad,
                                                        ),
                                                      ),
                                                      child: SlideTransition(
                                                        position: Tween<Offset>(
                                                                begin: Offset(
                                                                    0.0, 1.0),
                                                                end:
                                                                    Offset.zero)
                                                            .animate(
                                                          CurvedAnimation(
                                                            parent:
                                                                albumDetailsContentAnimationController,
                                                            curve: Curves
                                                                .easeInOutQuad,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            bottom: boxConstraints
                                                                    .maxHeight *
                                                                currentSongImageHeight *
                                                                (0.025),
                                                          ),
                                                          child: Text(
                                                            "About K.K",
                                                            style: TextStyle(
                                                                fontSize: 20.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    FadeTransition(
                                                      opacity: Tween<double>(
                                                              begin: 0.0,
                                                              end: 1.0)
                                                          .animate(
                                                        CurvedAnimation(
                                                          parent:
                                                              albumDetailsContentAnimationController,
                                                          curve: Interval(
                                                              0.25, 1.0,
                                                              curve: Curves
                                                                  .easeInOutQuad),
                                                        ),
                                                      ),
                                                      child: SlideTransition(
                                                        position: Tween<Offset>(
                                                                begin: Offset(
                                                                    0.0, 1.0),
                                                                end:
                                                                    Offset.zero)
                                                            .animate(
                                                          CurvedAnimation(
                                                            parent:
                                                                albumDetailsContentAnimationController,
                                                            curve: Interval(
                                                                0.25, 1.0,
                                                                curve: Curves
                                                                    .easeInOutQuad),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.only(
                                                              left: 7.5,
                                                              right: 7.5,
                                                              bottom: boxConstraints
                                                                      .maxHeight *
                                                                  currentSongImageHeight *
                                                                  (0.025)),
                                                          child: Text(
                                                            dummyText,
                                                            maxLines: 6,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    FadeTransition(
                                                      opacity: Tween<double>(
                                                              begin: 0.0,
                                                              end: 1.0)
                                                          .animate(
                                                        CurvedAnimation(
                                                          parent:
                                                              albumDetailsContentAnimationController,
                                                          curve: Interval(
                                                              0.5, 1.0,
                                                              curve: Curves
                                                                  .easeInOutQuad),
                                                        ),
                                                      ),
                                                      child: SlideTransition(
                                                        position: Tween<Offset>(
                                                                begin: Offset(
                                                                    0.0, 1.0),
                                                                end:
                                                                    Offset.zero)
                                                            .animate(
                                                          CurvedAnimation(
                                                            parent:
                                                                albumDetailsContentAnimationController,
                                                            curve: Interval(
                                                                0.5, 1.0,
                                                                curve: Curves
                                                                    .easeInOutQuad),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0,
                                                              top: boxConstraints
                                                                      .maxHeight *
                                                                  currentSongImageHeight *
                                                                  (0.05)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              CircularButtonContainer(
                                                                  iconSize:
                                                                      20.0,
                                                                  buttonRadius:
                                                                      20.0,
                                                                  iconData: Icons
                                                                      .share,
                                                                  onTap: () {}),
                                                              CircularButtonContainer(
                                                                  iconSize:
                                                                      20.0,
                                                                  buttonRadius:
                                                                      20.0,
                                                                  iconData: Icons
                                                                      .settings,
                                                                  onTap: () {}),
                                                              CircularButtonContainer(
                                                                  iconSize:
                                                                      20.0,
                                                                  buttonRadius:
                                                                      20.0,
                                                                  iconData: Icons
                                                                      .bookmark,
                                                                  onTap: () {}),
                                                              CircularButtonContainer(
                                                                  iconSize:
                                                                      20.0,
                                                                  buttonRadius:
                                                                      20.0,
                                                                  iconData: Icons
                                                                      .upcoming,
                                                                  onTap: () {}),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color:
                                                        Colors.grey.shade300),
                                                width: boxConstraints.maxWidth *
                                                    (0.8),
                                                height: boxConstraints
                                                        .maxHeight *
                                                    (currentSongImageHeight),
                                              ),
                                            ),
                                          );
                                        },
                                      ),

                                      //current song image

                                      AnimatedBuilder(
                                        animation:
                                            albumDetailsAnimationController,
                                        builder: (context, child) {
                                          double angle = 0 +
                                              Tween<double>(begin: 0, end: 180)
                                                  .animate(CurvedAnimation(
                                                      parent:
                                                          albumDetailsAnimationController,
                                                      curve:
                                                          Curves.easeInOutQuad))
                                                  .value;

                                          return Transform(
                                            alignment: Alignment.center,
                                            transform: Matrix4.identity()
                                              ..rotateY((pi / 180) * angle),
                                            child: Opacity(
                                              opacity: angle > 90 ? 0.0 : 1.0,
                                              child: SizedBox(
                                                width: boxConstraints.maxWidth *
                                                    (0.8),
                                                height: boxConstraints
                                                        .maxHeight *
                                                    (currentSongImageHeight),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Image.asset(
                                                      "assets/images/woman_a.jpg",
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),

                                  FadeTransition(
                                    opacity: Tween<double>(begin: 0.0, end: 1.0)
                                        .animate(
                                      CurvedAnimation(
                                        parent:
                                            currentTrackContentAnimationController,
                                        curve: Interval(0.0, 1.0,
                                            curve: Curves.easeInOutQuad),
                                      ),
                                    ),
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                              begin: Offset(0.0, 8.0),
                                              end: Offset.zero)
                                          .animate(
                                        CurvedAnimation(
                                          parent:
                                              currentTrackContentAnimationController,
                                          curve: Interval(0.0, 1.0,
                                              curve: Curves.easeInOutQuad),
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
                                  //

                                  FadeTransition(
                                    opacity: Tween<double>(begin: 0.0, end: 1.0)
                                        .animate(
                                      CurvedAnimation(
                                        parent:
                                            currentTrackContentAnimationController,
                                        curve: Interval(0.2, 1.0,
                                            curve: Curves.easeInOutQuad),
                                      ),
                                    ),
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                              begin: Offset(0.0, 8.0),
                                              end: Offset.zero)
                                          .animate(
                                        CurvedAnimation(
                                          parent:
                                              currentTrackContentAnimationController,
                                          curve: Interval(0.2, 1.0,
                                              curve: Curves.easeInOutQuad),
                                        ),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          top: 10.0,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              (0.1),
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              (0.1),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          //crossAxisAlignment: Cros,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                //
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.favorite),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 5.0, bottom: 15.0),
                                                  color: Colors.black,
                                                  width: 7.5,
                                                  height: 2.0,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 5.0, bottom: 15.0),
                                                  color: Colors.black,
                                                  width: 7.5,
                                                  height: 2.0,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 5.0, bottom: 15.0),
                                                  color: Colors.black,
                                                  width: 7.5,
                                                  height: 2.0,
                                                ),
                                              ],
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1.5),
                                                  color: Colors.black),
                                              height: 4.0,
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "00:00",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  "05:00",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  FadeTransition(
                                    opacity: Tween<double>(begin: 0.0, end: 1.0)
                                        .animate(
                                      CurvedAnimation(
                                        parent:
                                            currentTrackContentAnimationController,
                                        curve: Interval(0.4, 1.0,
                                            curve: Curves.easeInOutQuad),
                                      ),
                                    ),
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                              begin: Offset(0.0, 8.0),
                                              end: Offset.zero)
                                          .animate(
                                        CurvedAnimation(
                                          parent:
                                              currentTrackContentAnimationController,
                                          curve: Interval(0.4, 1.0,
                                              curve: Curves.easeInOutQuad),
                                        ),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(top: 10.0),
                                        child: Column(
                                          //crossAxisAlignment: Cros,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                    iconSize: 40.0,
                                                    onPressed: () {},
                                                    icon: Icon(
                                                        Icons.skip_previous)),
                                                CircularButtonContainer(
                                                    iconData: Icons.play_arrow,
                                                    onTap: () async {
                                                      albumDetailsAnimationController
                                                          .forward();
                                                      await Future.delayed(
                                                          Duration(
                                                              milliseconds:
                                                                  300));
                                                      albumDetailsContentAnimationController
                                                          .forward();
                                                    }),
                                                IconButton(
                                                    iconSize: 40.0,
                                                    onPressed: () async {},
                                                    icon:
                                                        Icon(Icons.skip_next)),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  FadeTransition(
                                    opacity: Tween<double>(begin: 0.0, end: 1.0)
                                        .animate(
                                      CurvedAnimation(
                                        parent:
                                            currentTrackContentAnimationController,
                                        curve: Interval(0.6, 1.0,
                                            curve: Curves.easeInOutQuad),
                                      ),
                                    ),
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                              begin: Offset(0.0, 8.0),
                                              end: Offset.zero)
                                          .animate(
                                        CurvedAnimation(
                                          parent:
                                              currentTrackContentAnimationController,
                                          curve: Interval(0.6, 1.0,
                                              curve: Curves.easeInOutQuad),
                                        ),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(top: 20.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Tracks",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Transform.rotate(
                                                alignment: Alignment.center,
                                                angle: (pi / 180) * 270,
                                                child: Icon(
                                                  Icons.arrow_back_ios,
                                                  size: 17.5,
                                                )),
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
