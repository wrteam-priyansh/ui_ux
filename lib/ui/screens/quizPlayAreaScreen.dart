import 'package:flutter/material.dart';

class QuizPlayAreaScreen extends StatefulWidget {
  QuizPlayAreaScreen({Key? key}) : super(key: key);

  @override
  _QuizPlayAreaScreenState createState() => _QuizPlayAreaScreenState();
}

class _QuizPlayAreaScreenState extends State<QuizPlayAreaScreen> with TickerProviderStateMixin {
  late AnimationController questionAnimationController;

  late AnimationController questionContentAnimationController;

  late AnimationController timerAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 10))..forward();

  late Animation<double> questionSlideAnimation;
  late Animation<double> questionScaleUpAnimation;

  late Animation<double> questionScaleDownAnimation;
  late Animation<double> questionContentAnimation;

  late int currentQuestionIndex = 0;

  @override
  void initState() {
    initializeAnimation();

    questionContentAnimationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    questionAnimationController.dispose();
    questionContentAnimationController.dispose();
    timerAnimationController.dispose();
    super.dispose();
  }

  void initializeAnimation() {
    questionContentAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    questionAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 525));

    questionSlideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: questionAnimationController, curve: Curves.easeInOut));

    questionScaleUpAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(CurvedAnimation(parent: questionAnimationController, curve: Interval(0.0, 0.5, curve: Curves.easeInQuad)));

    questionContentAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: questionContentAnimationController, curve: Curves.easeInQuad));
    questionScaleDownAnimation = Tween<double>(begin: 0.0, end: 0.05).animate(CurvedAnimation(parent: questionAnimationController, curve: Interval(0.5, 1.0, curve: Curves.easeOutQuad)));
  }

  void changeQuestion() {
    if (currentQuestionIndex != 4) {
      questionAnimationController.forward(from: 0.0).then((value) {
        questionAnimationController.dispose();
        questionContentAnimationController.dispose();

        setState(() {
          initializeAnimation();
          currentQuestionIndex++;
        });
        questionContentAnimationController.forward();
      });
    }
  }

  Widget _buildQuesitonContainer(double scale, int index, bool showContent) {
    Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * (0.05),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without",
            style: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor,
              fontSize: 17.0,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        OptionContainer(
          changeQuestion: changeQuestion,
        ),
      ],
    );

    return Center(
      child: Container(
        child: showContent
            ? SlideTransition(
                position: questionContentAnimation.drive(Tween<Offset>(begin: Offset(0.5, 0.0), end: Offset.zero)),
                child: FadeTransition(
                  opacity: questionContentAnimation,
                  child: child,
                ),
              )
            : Container(),
        transform: Matrix4.identity()..scale(scale),
        transformAlignment: Alignment.center,
        width: MediaQuery.of(context).size.width * (0.8),
        height: MediaQuery.of(context).size.height * (0.7),
        decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

  Widget _buildQuestion(int questionIndex) {
    if (currentQuestionIndex == questionIndex) {
      return FadeTransition(
          opacity: questionSlideAnimation.drive(Tween<double>(begin: 1.0, end: 0.0)),
          child: SlideTransition(child: _buildQuesitonContainer(1.0, questionIndex, true), position: questionSlideAnimation.drive(Tween<Offset>(begin: Offset.zero, end: Offset(-1.5, 0.0)))));
    } else if (questionIndex > currentQuestionIndex && (questionIndex == currentQuestionIndex + 1)) {
      return AnimatedBuilder(
          animation: questionAnimationController,
          builder: (context, child) {
            double scale = 0.95 + questionScaleUpAnimation.value - questionScaleDownAnimation.value;
            return _buildQuesitonContainer(scale, questionIndex, false);
          });
    } else if (questionIndex > currentQuestionIndex) {
      return _buildQuesitonContainer(1.0, questionIndex, false);
    }
    return Container();
  }

  List<Widget> _buildQuesitons() {
    List<Widget> children = [];

    for (var i = 0; i < 4; i++) {
      children.add(_buildQuestion(i));
    }

    children = children.reversed.toList();

    return children;
  }

  Widget _buildBackgroundCard(double opacity, double widthPercentage, double topMarginPercentage) {
    return Center(
      child: Opacity(
        opacity: opacity,
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * topMarginPercentage),
          width: MediaQuery.of(context).size.width * widthPercentage,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(25)),
        ),
      ),
    );
  }

  Widget _buildTimerContainer() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Stack(
          children: [
            Container(
              color: Colors.lightBlueAccent.withOpacity(0.5),
              height: 10.0,
              width: MediaQuery.of(context).size.width,
            ),
            AnimatedBuilder(
              animation: timerAnimationController,
              builder: (context, child) {
                return Container(
                  color: Colors.lightBlueAccent,
                  height: 10.0,
                  width: MediaQuery.of(context).size.width * timerAnimationController.value,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [_buildTimerContainer(), _buildBackgroundCard(0.85, 0.7, 0.05), _buildBackgroundCard(0.7, 0.6, 0.09), ..._buildQuesitons()],
      ),
    );
  }
}

class OptionContainer extends StatefulWidget {
  final Function changeQuestion;
  OptionContainer({Key? key, required this.changeQuestion}) : super(key: key);

  @override
  _OptionContainerState createState() => _OptionContainerState();
}

class _OptionContainerState extends State<OptionContainer> with TickerProviderStateMixin {
  final double optionWidth = 0.7;
  final double optionHeight = 0.09;

  late AnimationController animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
  late AnimationController topContainerAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
  late Animation<double> sizeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInQuad));

  late Animation<double> topLayerOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    parent: topContainerAnimationController,
    curve: Interval(0.0, 0.25, curve: Curves.easeInQuad),
  ));
  late Animation<double> topLayerContainerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: topContainerAnimationController, curve: Curves.easeInQuad));

  @override
  void dispose() {
    topContainerAnimationController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: () async {
                //add tap event

                await animationController.forward();
                animationController.reverse();
                await topContainerAnimationController.forward();
                widget.changeQuestion();
              },
              onTapUp: (tapUp) async {
                /*
                animationController.reverse();
                await topContainerAnimationController.forward();
                widget.changeQuestion();
                */
              },
              onTapDown: (_) {
                //animationController.forward();
              },
              child: AnimatedBuilder(
                animation: animationController,
                builder: (_, child) {
                  final height = sizeAnimation.drive(Tween<double>(begin: optionHeight, end: 0.07)).value;
                  final width = sizeAnimation.drive(Tween<double>(begin: optionWidth, end: optionWidth - 0.1)).value;
                  return Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), border: Border.all(color: Theme.of(context).scaffoldBackgroundColor)),
                    width: MediaQuery.of(context).size.width * width,
                    height: MediaQuery.of(context).size.height * height,
                  );
                },
              ),
            ),
          ),
          Center(
            child: IgnorePointer(
              ignoring: true,
              child: AnimatedBuilder(
                animation: topContainerAnimationController,
                builder: (_, child) {
                  final height = topLayerContainerAnimation.drive(Tween<double>(begin: 0.07, end: optionHeight)).value;
                  final width = topLayerContainerAnimation.drive(Tween<double>(begin: 0.2, end: optionWidth)).value;
                  final borderRadius = topLayerContainerAnimation.drive(Tween<double>(begin: 40.0, end: 20)).value;
                  return Opacity(
                    opacity: topLayerOpacityAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        color: Colors.tealAccent,
                      ),
                      width: MediaQuery.of(context).size.width * width,
                      height: MediaQuery.of(context).size.height * height,
                    ),
                  );
                },
              ),
            ),
          ),
          Center(
            child: IgnorePointer(
                ignoring: true,
                child: Container(
                  height: MediaQuery.of(context).size.height * (optionHeight),
                  width: MediaQuery.of(context).size.width * (optionWidth),
                  alignment: Alignment.center,
                  child: Text(
                    "You are awesome",
                    style: TextStyle(fontSize: 18.0),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
