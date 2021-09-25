import 'package:flutter/material.dart';

class QuizPlayAreaScreen extends StatefulWidget {
  QuizPlayAreaScreen({Key? key}) : super(key: key);

  @override
  _QuizPlayAreaScreenState createState() => _QuizPlayAreaScreenState();
}

class _QuizPlayAreaScreenState extends State<QuizPlayAreaScreen> with TickerProviderStateMixin {
  final int durationInSeconds = 25;

  //to animate current question
  late AnimationController questionAnimationController;

  //to animate content of question container (ex. question,image and options)
  late AnimationController questionContentAnimationController;

  ////change the duration of the timerAnimationController based on time requirement
  late AnimationController timerAnimationController = AnimationController(vsync: this, duration: Duration(seconds: durationInSeconds))..forward();

  //to slide the question container from right to left
  late Animation<double> questionSlideAnimation;

  //to scale up the second question
  late Animation<double> questionScaleUpAnimation;

  //to scale down the second question
  late Animation<double> questionScaleDownAnimation;

  //to slude the question content from right to left
  late Animation<double> questionContentAnimation;

  late int currentQuestionIndex = 0;

  @override
  void initState() {
    //init animation
    initializeAnimation();

    //load question content initially
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
    //
    questionContentAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    questionAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 525));

    questionSlideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: questionAnimationController, curve: Curves.easeInOut));

    questionScaleUpAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(CurvedAnimation(parent: questionAnimationController, curve: Interval(0.0, 0.5, curve: Curves.easeInQuad)));

    questionContentAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: questionContentAnimationController, curve: Curves.easeInQuad));
    questionScaleDownAnimation = Tween<double>(begin: 0.0, end: 0.05).animate(CurvedAnimation(parent: questionAnimationController, curve: Interval(0.5, 1.0, curve: Curves.easeOutQuad)));
  }

  //to change question
  void changeQuestion() {
    //
    if (currentQuestionIndex != 4) {
      //(lenght - 1) of question list
      questionAnimationController.forward(from: 0.0).then((value) {
        //need to dispose the animation controllers
        questionAnimationController.dispose();
        questionContentAnimationController.dispose();

        //initializeAnimation again
        setState(() {
          initializeAnimation();
          currentQuestionIndex++;
        });
        //load content(options, image etc) of question
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
        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

  Widget _buildQuestion(int questionIndex) {
    //if current question index is same as question index means
    //it is current question and will be on top
    //so we need to add animation that slide and fade this question
    if (currentQuestionIndex == questionIndex) {
      return FadeTransition(
          opacity: questionSlideAnimation.drive(Tween<double>(begin: 1.0, end: 0.0)),
          child: SlideTransition(child: _buildQuesitonContainer(1.0, questionIndex, true), position: questionSlideAnimation.drive(Tween<Offset>(begin: Offset.zero, end: Offset(-1.5, 0.0)))));
    }
    //if the question is second or after current question
    //so we need to animation that scale this question
    //initial scale of this question is 0.95

    else if (questionIndex > currentQuestionIndex && (questionIndex == currentQuestionIndex + 1)) {
      return AnimatedBuilder(
          animation: questionAnimationController,
          builder: (context, child) {
            double scale = 0.95 + questionScaleUpAnimation.value - questionScaleDownAnimation.value;
            return _buildQuesitonContainer(scale, questionIndex, false);
          });
    }
    //to build question except top 2

    else if (questionIndex > currentQuestionIndex) {
      return _buildQuesitonContainer(1.0, questionIndex, false);
    }
    //if the question is already animated that show empty container
    return Container();
  }

  //to build questions
  List<Widget> _buildQuesitons() {
    List<Widget> children = [];

    //loop terminate condition will be questions.length instead of 4
    for (var i = 0; i < 4; i++) {
      //add question
      children.add(_buildQuestion(i));
    }
    //need to reverse the list in order to display 1st question in top
    children = children.reversed.toList();

    return children;
  }

  //work as base card for question container
  Widget _buildBackgroundCard(double opacity, double widthPercentage, double topMarginPercentage) {
    return Center(
      child: Opacity(
        opacity: opacity,
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * topMarginPercentage),
          width: MediaQuery.of(context).size.width * widthPercentage,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(25)),
        ),
      ),
    );
  }

  //to build timer
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

  int determinePoints() {
    int points = 10;
    double secondsTakenToAnswer = (durationInSeconds * timerAnimationController.value);

    print(secondsTakenToAnswer);
    if (secondsTakenToAnswer <= 2) {
      return points * 2;
    } else if (secondsTakenToAnswer <= 4) {
      return (points * 1.5).toInt();
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        timerAnimationController.stop();
        print(determinePoints());
      }),
      body: Stack(
        children: [_buildTimerContainer(), _buildBackgroundCard(0.85, 0.7, 0.05), _buildBackgroundCard(0.7, 0.6, 0.09), ..._buildQuesitons()],
      ),
    );
  }
}

//
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
