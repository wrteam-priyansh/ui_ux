import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ui_ux/ui/screens/movieCharacterUx/models/character.dart';

class CharacterDetailsScreen extends StatefulWidget {
  final int characterIndex;
  final Character character;
  CharacterDetailsScreen(
      {Key? key, required this.character, required this.characterIndex})
      : super(key: key);

  @override
  State<CharacterDetailsScreen> createState() => _CharacterDetailsScreenState();
}

class _CharacterDetailsScreenState extends State<CharacterDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _bottomMenuHeightAnimationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 900));

  late Animation<double> _bottomMenuHeightUpAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _bottomMenuHeightAnimationController,
          curve: Interval(0.0, 0.6, curve: Curves.easeInOut)));

  late Animation<double> _bottomMenuHeightDownAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _bottomMenuHeightAnimationController,
          curve: Interval(0.6, 1.0, curve: Curves.easeInOut)));

  late Animation<double> _backButtonAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _bottomMenuHeightAnimationController,
          curve: Interval(0.0, 0.6, curve: Curves.easeInOut)));

  late AnimationController _latestNewsTitleAnimationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500));

  late Animation<double> _latestNewsTitleFadeAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _latestNewsTitleAnimationController,
          curve: Curves.easeInOut));

  late List<AnimationController> _latestNewsContainerAnimationControllers = [];

  late AnimationController _relatedMoviesTitleAnimationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500));

  late Animation<double> _relatedMoviesTitleFadeAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _latestNewsTitleAnimationController,
          curve: Curves.easeInOut));

  late List<AnimationController> _relatedMoviesContainerAnimationControllers =
      [];

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  Future<void> startAnimation() async {
    for (var i = 0; i < 3; i++) {
      _latestNewsContainerAnimationControllers.add(AnimationController(
          vsync: this, duration: Duration(milliseconds: 400)));

      _relatedMoviesContainerAnimationControllers.add(AnimationController(
          vsync: this, duration: Duration(milliseconds: 400)));
    }
    await Future.delayed(Duration(milliseconds: 250));

    await _bottomMenuHeightAnimationController.forward();

    _latestNewsTitleAnimationController.forward();
    await _relatedMoviesTitleAnimationController.forward();
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * (0.025),
            top: MediaQuery.of(context).padding.top +
                MediaQuery.of(context).size.height * (0.0125)),
        child: FadeTransition(
          opacity: _backButtonAnimation,
          child: IconButton(
              onPressed: () {
                onBackCallback();
              },
              icon: Transform.rotate(
                angle: (pi / 180) * 270,
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              )),
        ),
      ),
    );
  }

  void onBackCallback() async {
    if (!_bottomMenuHeightAnimationController.isAnimating) {
      await _bottomMenuHeightAnimationController.reverse();
      Navigator.of(context).pop();
    }
  }

  Widget _buildBackgroundContainer() {
    return Hero(
      tag: "${widget.characterIndex}backgroundColor",
      child: Container(
        color: widget.character.backgroundColor,
      ),
    );
  }

  Widget _buildCharacterName() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * (0.365),
          left: MediaQuery.of(context).size.width * (0.075),
        ),
        child: Hero(
          tag: "${widget.characterIndex}name",
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              "${widget.character.name}",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomMenu() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedBuilder(
          animation: _bottomMenuHeightAnimationController,
          builder: (context, _) {
            final height = (MediaQuery.of(context).size.height *
                    0.45 *
                    _bottomMenuHeightUpAnimation.value) -
                (MediaQuery.of(context).size.height *
                    0.025 *
                    _bottomMenuHeightDownAnimation.value);

            return Container(
              child: _bottomMenuHeightAnimationController.value != 1.0
                  ? SizedBox()
                  : LayoutBuilder(builder: (context, boxConstraints) {
                      return Column(
                        children: [
                          SizedBox(
                            height: boxConstraints.maxHeight * (0.075),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width *
                                      (0.075)),
                              child: FadeTransition(
                                opacity: _latestNewsTitleFadeAnimation,
                                child: Text(
                                  "Latest News",
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: boxConstraints.maxHeight * (0.05),
                          ),
                          Flexible(
                            child: Container(
                              clipBehavior: Clip.none,
                              child: ListView.builder(
                                  clipBehavior: Clip.none,
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          (0.075)),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 3,
                                  itemBuilder: ((context, index) =>
                                      LatestNewsContainer(
                                          initialAnimationDelayInMilliSeconds:
                                              500,
                                          animationController:
                                              _latestNewsContainerAnimationControllers[
                                                  index],
                                          index: index,
                                          character: widget.character))),
                              height: boxConstraints.maxHeight * (0.225),
                            ),
                          ),
                          SizedBox(
                            height: boxConstraints.maxHeight * (0.05),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width *
                                      (0.075)),
                              child: FadeTransition(
                                opacity: _relatedMoviesTitleFadeAnimation,
                                child: Text(
                                  "Related Movies",
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: boxConstraints.maxHeight * (0.05),
                          ),
                          Container(
                            clipBehavior: Clip.none,
                            child: ListView.builder(
                                clipBehavior: Clip.none,
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        (0.075)),
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    _relatedMoviesContainerAnimationControllers
                                        .length,
                                itemBuilder: ((context, index) =>
                                    LatestNewsContainer(
                                        initialAnimationDelayInMilliSeconds:
                                            1000,
                                        animationController:
                                            _relatedMoviesContainerAnimationControllers[
                                                index],
                                        index: index,
                                        character: widget.character))),
                            height: boxConstraints.maxHeight * (0.225),
                          ),
                        ],
                      );
                    }),
              width: MediaQuery.of(context).size.width,
              height: height,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
            );
          }),
    );
  }

  Widget _buildDescription() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * (0.425),
          left: MediaQuery.of(context).size.width * (0.075),
          right: MediaQuery.of(context).size.width * (0.075),
        ),
        child: Hero(
          tag: "${widget.characterIndex}description",
          child: Material(
            type: MaterialType.transparency,
            child: Text("${widget.character.description}",
                textAlign: TextAlign.start,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        onBackCallback();
        return Future.value(false);
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackgroundContainer(),
            _buildCharacterName(),
            _buildDescription(),

            _buildBottomMenu(),
            //
            _buildBackButton(),
          ],
        ),
      ),
    );
  }
}

class LatestNewsContainer extends StatefulWidget {
  final AnimationController animationController;
  final int initialAnimationDelayInMilliSeconds;

  final Character character;
  final int index;
  const LatestNewsContainer(
      {Key? key,
      required this.initialAnimationDelayInMilliSeconds,
      required this.animationController,
      required this.index,
      required this.character})
      : super(key: key);

  @override
  State<LatestNewsContainer> createState() => _LatestNewsContainerState();
}

class _LatestNewsContainerState extends State<LatestNewsContainer> {
  late Animation<double> scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(
          parent: widget.animationController, curve: Curves.easeInOut));

  late Animation<double> fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(
          parent: widget.animationController, curve: Curves.easeInOut));

  late Animation<Offset> slideAnimation = Tween<Offset>(
          begin: Offset(0.0, 0.25 + (widget.index * 0.1)), end: Offset.zero)
      .animate(CurvedAnimation(
          parent: widget.animationController, curve: Curves.easeInOut));

  @override
  void initState() {
    Future.delayed(
        Duration(
            milliseconds: widget.initialAnimationDelayInMilliSeconds +
                (widget.index * 200)), () {
      widget.animationController.forward();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          margin: EdgeInsets.only(right: 15.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: widget.character.backgroundColor),
          width: MediaQuery.of(context).size.width * (0.4),
        ),
      ),
    );
  }
}
