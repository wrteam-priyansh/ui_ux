import 'dart:math';

import 'package:flutter/material.dart';

class PopularVideoUx extends StatefulWidget {
  final Size screenSize;
  PopularVideoUx({Key? key, required this.screenSize}) : super(key: key);

  @override
  _PopularVideoUxState createState() => _PopularVideoUxState();
}

class _PopularVideoUxState extends State<PopularVideoUx>
    with TickerProviderStateMixin {
  late AnimationController animationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 900));
  late Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(
          parent: animationController, curve: Curves.easeInOutQuad));

  late AnimationController secondCircleAnimationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 900));
  late Animation<double> secondCircleAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: secondCircleAnimationController,
          curve: Curves.easeInOutQuad));

  late List<Color> videos = [
    Colors.pinkAccent,
    Colors.amberAccent,
    Colors.yellowAccent,
    Colors.amberAccent,
    Colors.tealAccent,
    Colors.limeAccent
  ];
  int totalCardDiplayedInScreen = 4;

  late List<AnimationController> videoCardAnimationControllers = [];
  late List<Tween<double>> videoCardScaleTweens = [];
  late List<Tween<double>> videoCardFadeTweens = [];
  late List<Tween<double>> videoCardTopPaddingTweens = [];
  late List<Tween<double>> videoCardleftPositionTweens = [];
  late List<Animation> videoCardAnimations = [];
  late int inBetweenCardSliderDurationDiffrence = 225;

  late Tween<double> topVideoCardDetailsScaleTween =
      Tween<double>(begin: 1.3, end: 1.0);

  //video card details animations

  late List<AnimationController> videoCardDetailsAnimationControllers = [];
  late List<Animation<double>> videoCardDetailsAnimations = [];

  late List<Tween<double>> videoCardDetailsAngleTweens = [];
  late List<Tween<double>> videoCardDetailsleftPositionTweens = [];

  //
  int videoCardDetailsAnimationDuration = 600;

  late int currentTopVideoCardIndex = videos.length - 1;
  int videoCardAnimationDurationInMilliseconds = 775;
  late double inBetweenVideoCardTopPadding = widget.screenSize.height * (0.035);
  late double videoCardsScaleDifference = 0.115;

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < videos.length; i++) {
      videoCardAnimationControllers.add(AnimationController(
          vsync: this,
          duration: Duration(
              milliseconds: videoCardAnimationDurationInMilliseconds)));
      videoCardAnimations.add(Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
              parent: videoCardAnimationControllers[i],
              curve: Curves.easeInOut)));
      videoCardScaleTweens.add(Tween<double>(
          begin: _calculateBeginVideoCardScale(i),
          end: _calculateEndVideoCardScale(i)));
      if (i >= (videos.length - totalCardDiplayedInScreen)) {
        videoCardFadeTweens.add(Tween<double>(begin: 1.0, end: 1.0));
      } else {
        videoCardFadeTweens.add(Tween<double>(begin: 0.0, end: 0.0));
      }
      videoCardleftPositionTweens.add(Tween<double>(
          begin: -widget.screenSize.width * (0.8) * (1.5),
          end: widget.screenSize.width * (0.1)));
      videoCardTopPaddingTweens.add(Tween<double>(
          begin: _calculateVideoCardTopPosition(i),
          end: _calculateVideoCardTopPosition(i)));

      videoCardDetailsAnimationControllers.add(AnimationController(
          vsync: this,
          duration: Duration(milliseconds: videoCardDetailsAnimationDuration)));
      if (i == currentTopVideoCardIndex) {
        videoCardDetailsleftPositionTweens.add(Tween<double>(
            begin: widget.screenSize.width * (-0.9),
            end: widget.screenSize.width * (0.15)));
        videoCardDetailsAngleTweens.add(Tween<double>(begin: 0.0, end: 0.0));
        videoCardDetailsAnimations.add(Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
                parent: videoCardDetailsAnimationControllers[i],
                curve: Curves.easeInOut)));
      } else {
        videoCardDetailsleftPositionTweens.add(Tween<double>(
            begin: widget.screenSize.width * (1.15),
            end: widget.screenSize.width * (0.15)));
        videoCardDetailsAngleTweens.add(Tween<double>(begin: 25, end: 25));
        videoCardDetailsAnimations.add(Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
                parent: videoCardDetailsAnimationControllers[i],
                curve: Curves.easeInOut)));
      }
    }
    setState(() {});

    startAnimation();
  }

  @override
  void dispose() {
    animationController.dispose();
    secondCircleAnimationController.dispose();
    videoCardAnimationControllers.forEach((element) {
      element.dispose();
    });
    videoCardDetailsAnimationControllers.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  void startAnimation() async {
    animationController.forward();

    Future.delayed(Duration(milliseconds: 200))
        .then((value) => secondCircleAnimationController.forward());

    for (var i = (videos.length - totalCardDiplayedInScreen);
        i < videos.length;
        i++) {
      videoCardAnimationControllers[i].forward();

      await Future.delayed(
          Duration(milliseconds: inBetweenCardSliderDurationDiffrence));
    }
    videoCardDetailsAnimationControllers[currentTopVideoCardIndex].forward();

    for (var i = 0; i < (videos.length - totalCardDiplayedInScreen); i++) {
      videoCardAnimationControllers[i].forward();
    }
  }

  double _calculateBeginVideoCardScale(int index) {
    double scale = 1.75; //max scale
    scale = scale - (videos.length - 1 - index) * (0.1);
    scale = scale < 0.1 ? 0.1 : scale;
    return scale;
  }

  double _calculateEndVideoCardScale(int index) {
    double scale = 1.0; //max scale
    scale = scale - (videos.length - 1 - index) * videoCardsScaleDifference;
    scale = scale < 0.1 ? 0.1 : scale;
    return scale;
  }

  double _calculateVideoCardTopPosition(int index) {
    return widget.screenSize.height * (0.5) -
        widget.screenSize.height * (0.2) -
        (videos.length - 1 - index) * inBetweenVideoCardTopPadding;
  }

  Widget _buildVideoCard(int index) {
    return AnimatedBuilder(
        animation: videoCardAnimationControllers[index],
        builder: (context, _) {
          final double scale = videoCardAnimations[index]
              .drive(videoCardScaleTweens[index])
              .value;
          final double leftPosition = videoCardAnimations[index]
              .drive(videoCardleftPositionTweens[index])
              .value;
          double opacity = videoCardAnimations[index]
              .drive(videoCardFadeTweens[index])
              .value;
          final topPosition = videoCardAnimations[index]
              .drive(videoCardTopPaddingTweens[index])
              .value;

          return Positioned(
            top: topPosition, //,
            left: leftPosition,
            child: Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: GestureDetector(
                  onTap: () {
                    //only top card will be tappable
                    if (index == currentTopVideoCardIndex) {
                      //
                      //determine base end condition
                      int endCondition = (index >= totalCardDiplayedInScreen)
                          ? (currentTopVideoCardIndex -
                              totalCardDiplayedInScreen)
                          : 0;
                      for (var i = currentTopVideoCardIndex;
                          i >= endCondition;
                          i--) {
                        //only top card will be go up side
                        if (i == currentTopVideoCardIndex) {
                          videoCardTopPaddingTweens[i] = Tween<double>(
                              begin: videoCardTopPaddingTweens[i].end,
                              end: widget.screenSize.height * (-0.4));
                          videoCardScaleTweens[i] = Tween<double>(
                              begin: videoCardScaleTweens[i].end,
                              end: videoCardScaleTweens[i].end);
                          videoCardleftPositionTweens[i] = Tween(
                              begin: videoCardleftPositionTweens[i].end,
                              end: videoCardleftPositionTweens[i].end);
                          videoCardFadeTweens[i] =
                              Tween<double>(begin: 1.0, end: 1.0);
                        } else if (i == endCondition) {
                          videoCardTopPaddingTweens[i] = Tween<double>(
                              begin: videoCardTopPaddingTweens[i].end,
                              end: videoCardTopPaddingTweens[i].end! +
                                  inBetweenVideoCardTopPadding);
                          videoCardScaleTweens[i] = Tween<double>(
                              begin: videoCardScaleTweens[i].end,
                              end: videoCardScaleTweens[i].end! +
                                  videoCardsScaleDifference);

                          videoCardleftPositionTweens[i] = Tween(
                              begin: videoCardleftPositionTweens[i].end,
                              end: videoCardleftPositionTweens[i].end);
                          if (index >= totalCardDiplayedInScreen) {
                            videoCardFadeTweens[i] =
                                Tween<double>(begin: 0.0, end: 1.0);
                          } else {
                            videoCardFadeTweens[i] =
                                Tween<double>(begin: 1.0, end: 1.0);
                          }
                        } else {
                          //if it is in beetween
                          videoCardTopPaddingTweens[i] = Tween<double>(
                              begin: videoCardTopPaddingTweens[i].end,
                              end: videoCardTopPaddingTweens[i].end! +
                                  inBetweenVideoCardTopPadding);
                          videoCardScaleTweens[i] = Tween<double>(
                              begin: videoCardScaleTweens[i].end,
                              end: videoCardScaleTweens[i].end! +
                                  videoCardsScaleDifference);
                          videoCardleftPositionTweens[i] = Tween(
                              begin: videoCardleftPositionTweens[i].end,
                              end: videoCardleftPositionTweens[i].end);
                          videoCardFadeTweens[i] =
                              Tween<double>(begin: 1.0, end: 1.0);
                        }

                        //
                        videoCardAnimationControllers[i].dispose();
                        videoCardAnimationControllers[i] = AnimationController(
                            vsync: this,
                            duration: Duration(
                                milliseconds:
                                    videoCardDetailsAnimationDuration));
                        videoCardAnimations[i] =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: videoCardAnimationControllers[i],
                                    curve: Curves.easeInOut));
                      }

                      if (endCondition > 0) {
                        //if there is more card behind then change those card's scale and topPadding
                        for (var i = (currentTopVideoCardIndex -
                                totalCardDiplayedInScreen -
                                1);
                            i >= 0;
                            i--) {
                          videoCardAnimationControllers[i].dispose();
                          videoCardAnimationControllers[i] =
                              AnimationController(
                                  vsync: this,
                                  duration: Duration(
                                      milliseconds:
                                          videoCardDetailsAnimationDuration));
                          videoCardAnimations[i] =
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                      parent: videoCardAnimationControllers[i],
                                      curve: Curves.easeInOut));
                          videoCardTopPaddingTweens[i] = Tween<double>(
                              begin: videoCardTopPaddingTweens[i].end,
                              end: videoCardTopPaddingTweens[i].end! +
                                  inBetweenVideoCardTopPadding);
                          videoCardScaleTweens[i] = Tween<double>(
                              begin: videoCardScaleTweens[i].end,
                              end: videoCardScaleTweens[i].end! +
                                  videoCardsScaleDifference);
                        }
                      }

                      //animate top video card details
                      videoCardDetailsAnimationControllers[
                              currentTopVideoCardIndex]
                          .dispose();
                      videoCardDetailsAnimationControllers[
                              currentTopVideoCardIndex] =
                          AnimationController(
                              vsync: this,
                              duration: Duration(
                                  milliseconds:
                                      videoCardDetailsAnimationDuration));
                      videoCardDetailsAnimations[currentTopVideoCardIndex] =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: videoCardDetailsAnimationControllers[
                                      currentTopVideoCardIndex],
                                  curve: Curves.easeInOut));
                      videoCardDetailsAngleTweens[currentTopVideoCardIndex] =
                          Tween<double>(begin: 0.0, end: -25.0);
                      videoCardDetailsleftPositionTweens[
                              currentTopVideoCardIndex] =
                          Tween<double>(
                              begin: widget.screenSize.width * (0.15),
                              end: widget.screenSize.width * (-0.9));
                      //animate second top card index
                      if (currentTopVideoCardIndex > 0) {
                        videoCardDetailsAnimationControllers[
                                currentTopVideoCardIndex - 1]
                            .dispose();
                        videoCardDetailsAnimationControllers[
                                currentTopVideoCardIndex - 1] =
                            AnimationController(
                                vsync: this,
                                duration: Duration(
                                    milliseconds:
                                        videoCardDetailsAnimationDuration));
                        videoCardDetailsAnimations[
                                currentTopVideoCardIndex - 1] =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                    parent:
                                        videoCardDetailsAnimationControllers[
                                            currentTopVideoCardIndex - 1],
                                    curve: Curves.easeInOut));
                        videoCardDetailsAngleTweens[currentTopVideoCardIndex -
                            1] = Tween<double>(begin: 25.0, end: 0.0);
                        videoCardDetailsleftPositionTweens[
                                currentTopVideoCardIndex - 1] =
                            Tween<double>(
                                begin: widget.screenSize.width * (1.15),
                                end: widget.screenSize.width * (0.15));
                      }

                      ///
                      ///
                      setState(() {});
                      for (var i = currentTopVideoCardIndex; i >= 0; i--) {
                        videoCardAnimationControllers[i].forward();
                      }
                      videoCardDetailsAnimationControllers[
                              currentTopVideoCardIndex]
                          .forward();
                      if (currentTopVideoCardIndex > 0) {
                        videoCardDetailsAnimationControllers[
                                currentTopVideoCardIndex - 1]
                            .forward();
                      }
                      currentTopVideoCardIndex--;
                    }
                  },
                  child: Container(
                    child: Center(
                        child: Text(
                      "$index",
                      style: TextStyle(fontSize: 20),
                    )),
                    width: MediaQuery.of(context).size.width * (0.8),
                    height: MediaQuery.of(context).size.height * (0.4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: videos[index]),
                  ),
                ),
              ),
            ),
          );
        });
  }

  List<Widget> _buildVideoCards() {
    final List<Widget> children = [];
    for (var i = 0; i < videos.length; i++) {
      children.add(_buildVideoCard(i));
    }
    return children;
  }

  Widget _buildBottomNavigationContainer() {
    return Positioned(
      bottom: 0,
      child: SlideTransition(
        position: animation
            .drive<Offset>(Tween(begin: Offset(0.0, 1.0), end: Offset.zero)),
        child: Container(
          height: MediaQuery.of(context).size.height * (0.075),
          width: MediaQuery.of(context).size.width,
          color: Colors.lightGreenAccent,
        ),
      ),
    );
  }

  Widget _buildVideoDetailsContainer(int index) {
    return AnimatedBuilder(
        animation: videoCardDetailsAnimationControllers[index],
        builder: (context, _) {
          double leftPosition = videoCardDetailsAnimations[index]
              .drive(videoCardDetailsleftPositionTweens[index])
              .value;
          double angle = videoCardDetailsAnimations[index]
              .drive(videoCardDetailsAngleTweens[index])
              .value;
          //TODO add initial scale by taking seperate animation
          //double  scale = index == (videos.length - 1) ? videoCardDetailsAnimations[index].drive(topVideoCardDetailsScaleTween).value : 1.0;

          return Positioned(
            top: MediaQuery.of(context).size.height * (0.575),
            left: leftPosition,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..scale(1.0)
                ..rotateZ(angle * (pi / 180)),
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 5),
                        blurRadius: 5.0,
                        color: Colors.black12,
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0)),
                width: MediaQuery.of(context).size.width * (0.7),
                height: MediaQuery.of(context).size.height * (0.25),
              ),
            ),
          );
        });
  }

  List<Widget> _buildVideoDetailsContainers() {
    final List<Widget> children = [];
    for (var i = 0; i < videos.length; i++) {
      children.add(_buildVideoDetailsContainer(i));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
              animation: secondCircleAnimationController,
              builder: (context, child) {
                final double scale = secondCircleAnimation
                    .drive(Tween<double>(begin: 4, end: 3.0))
                    .value;
                final double leftAndTopPosition = secondCircleAnimation
                    .drive(Tween<double>(begin: 0.0, end: 1.0))
                    .value;

                return Positioned(
                  top:
                      -MediaQuery.of(context).size.width * (leftAndTopPosition),
                  left: -MediaQuery.of(context).size.width *
                      (0.75) *
                      leftAndTopPosition,
                  child: Transform.scale(
                    alignment: Alignment.center,
                    scale: scale,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.5),
                          color: Colors.greenAccent.shade100),
                    ),
                  ),
                );
              }),
          AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                final double scale =
                    animation.drive(Tween<double>(begin: 4, end: 3.0)).value;
                final double leftAndTopPosition =
                    animation.drive(Tween<double>(begin: 0.0, end: 1.0)).value;
                final double inBetweenMargin =
                    animation.drive(Tween<double>(begin: -120, end: -50)).value;
                return Positioned(
                  top: inBetweenMargin +
                      -MediaQuery.of(context).size.width * (leftAndTopPosition),
                  left: inBetweenMargin +
                      -MediaQuery.of(context).size.width *
                          (0.75) *
                          leftAndTopPosition,
                  child: Transform.scale(
                    alignment: Alignment.center,
                    scale: scale,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.5),
                          color: Colors.white),
                    ),
                  ),
                );
              }),
          ..._buildVideoCards(),
          ..._buildVideoDetailsContainers(),
          _buildBottomNavigationContainer()
        ],
      ),
    );
  }
}
