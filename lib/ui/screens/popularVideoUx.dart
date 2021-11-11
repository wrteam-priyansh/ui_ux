import 'package:flutter/material.dart';

class PopularVideoUx extends StatefulWidget {
  PopularVideoUx({Key? key}) : super(key: key);

  @override
  _PopularVideoUxState createState() => _PopularVideoUxState();
}

class _PopularVideoUxState extends State<PopularVideoUx> with TickerProviderStateMixin {
  late AnimationController animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
  late Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOutQuad));

  late AnimationController secondCircleAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
  late Animation<double> secondCircleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: secondCircleAnimationController, curve: Curves.easeInOutQuad));

  late List<Color> videos = [Colors.pinkAccent, Colors.amberAccent, Colors.yellowAccent, Colors.amberAccent, Colors.tealAccent, Colors.limeAccent];
  int totalCardDiplayedInScreen = 3;

  late List<AnimationController> videoCardAnimationControllers = [];
  late List<Animation> videoCardSlideAnimations = [];

  late int inBetweenCardSliderDurationDiffrence = 225;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < videos.length; i++) {
      int durationInMilliseconds = 875;
      // if (i >= ((videos.length - totalCardDiplayedInScreen))) {
      //   durationInMilliseconds = durationInMilliseconds - inBetweenCardSliderDurationDiffrence * (i - (videos.length - totalCardDiplayedInScreen));
      // }
      videoCardAnimationControllers.add(AnimationController(vsync: this, duration: Duration(milliseconds: durationInMilliseconds)));
      videoCardSlideAnimations.add(Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: videoCardAnimationControllers[i], curve: Curves.easeInOut)));
    }

    startAnimation();
  }

  @override
  void dispose() {
    animationController.dispose();
    secondCircleAnimationController.dispose();
    videoCardAnimationControllers.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  void startAnimation() async {
    animationController.forward();

    Future.delayed(Duration(milliseconds: 200)).then((value) => secondCircleAnimationController.forward());

    for (var i = (videos.length - totalCardDiplayedInScreen); i < videos.length; i++) {
      videoCardAnimationControllers[i].forward();
      await Future.delayed(Duration(milliseconds: inBetweenCardSliderDurationDiffrence));
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
    scale = scale - (videos.length - 1 - index) * (0.115);
    scale = scale < 0.1 ? 0.1 : scale;
    return scale;
  }

  Widget _buildVideoDetialCard(int index) {
    return AnimatedBuilder(
        animation: videoCardAnimationControllers[index],
        builder: (context, _) {
          final double scale = videoCardSlideAnimations[index].drive(Tween<double>(begin: _calculateBeginVideoCardScale(index), end: _calculateEndVideoCardScale(index))).value;
          final double beginLeftPosition = -MediaQuery.of(context).size.width * (0.8) * (1.5); //- (MediaQuery.of(context).size.width * (0.5) * index)
          final double leftPosition = videoCardSlideAnimations[index].drive(Tween<double>(begin: beginLeftPosition, end: MediaQuery.of(context).size.width * (0.1))).value;
          final double opacity = index >= (videos.length - 1 - totalCardDiplayedInScreen) ? 1.0 : 0.0;

          return Positioned(
            top: MediaQuery.of(context).size.height * (0.5) - MediaQuery.of(context).size.height * (0.2) - (videos.length - 1 - index) * (21), //,
            left: leftPosition,
            child: Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: Container(
                  child: Center(child: Text("$index")),
                  width: MediaQuery.of(context).size.width * (0.8),
                  height: MediaQuery.of(context).size.height * (0.4),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: videos[index]),
                ),
              ),
            ),
          );
        });
  }

  List<Widget> _buildVideoDetailCards() {
    final List<Widget> children = [];
    for (var i = 0; i < videos.length; i++) {
      children.add(_buildVideoDetialCard(i));
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
                final double scale = secondCircleAnimation.drive(Tween<double>(begin: 4, end: 3.0)).value;
                final double leftAndTopPosition = secondCircleAnimation.drive(Tween<double>(begin: 0.0, end: 1.0)).value;

                return Positioned(
                  top: -MediaQuery.of(context).size.width * (leftAndTopPosition),
                  left: -MediaQuery.of(context).size.width * (0.75) * leftAndTopPosition,
                  child: Transform.scale(
                    alignment: Alignment.center,
                    scale: scale,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.5), color: Colors.greenAccent.shade100),
                    ),
                  ),
                );
              }),
          AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                final double scale = animation.drive(Tween<double>(begin: 4, end: 3.0)).value;
                final double leftAndTopPosition = animation.drive(Tween<double>(begin: 0.0, end: 1.0)).value;
                final double inBetweenMargin = animation.drive(Tween<double>(begin: -120, end: -50)).value;
                return Positioned(
                  top: inBetweenMargin + -MediaQuery.of(context).size.width * (leftAndTopPosition),
                  left: inBetweenMargin + -MediaQuery.of(context).size.width * (0.75) * leftAndTopPosition,
                  child: Transform.scale(
                    alignment: Alignment.center,
                    scale: scale,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.5), color: Colors.white),
                    ),
                  ),
                );
              }),
          ..._buildVideoDetailCards(),
        ],
      ),
    );
  }
}
