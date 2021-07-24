import 'package:flutter/material.dart';

class SelectWordAnimationScreen extends StatefulWidget {
  SelectWordAnimationScreen({Key? key}) : super(key: key);

  @override
  _SelectWordAnimationScreenState createState() => _SelectWordAnimationScreenState();
}

class _SelectWordAnimationScreenState extends State<SelectWordAnimationScreen> with TickerProviderStateMixin {
  late List<AnimationController> controllers = [];
  late List<Animation<double>> animations = [];
  late List<String> letters = ["", "", ""];
  late int currentSelectedIndex = 0;

  @override
  void initState() {
    for (int i = 0; i < 3; i++) {
      controllers.add(AnimationController(vsync: this, duration: Duration(milliseconds: 300)));
      animations.add(Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: controllers[i], curve: Curves.easeInOutExpo, reverseCurve: Curves.easeInOutExpo)));
    }
    super.initState();
  }

  List<Widget> _buildAnswers() {
    List<Widget> children = [];

    for (var i = 0; i < letters.length; i++) {
      children.add(Container(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, width: 1.5))),
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        height: 50.0,
        width: 35.0,
        child: AnimatedBuilder(
          animation: controllers[i],
          builder: (context, child) {
            return Container();
          },
          child: SlideTransition(
              position: animations[i].drive(Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)),
              child: Text(
                letters[i],
                style: TextStyle(fontSize: 20.0),
              )),
        ),
      ));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Container(
                child: Stack(
                  clipBehavior: Clip.antiAlias,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(25.0),
                        color: Colors.amberAccent,
                      ),
                    ),
                    Positioned(
                      top: -MediaQuery.of(context).size.width * (0.25),
                      right: -MediaQuery.of(context).size.width * (0.25),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * (0.3)),
                          color: Colors.white54,
                        ),
                        width: MediaQuery.of(context).size.width * (0.6),
                        height: MediaQuery.of(context).size.width * (0.6),
                      ),
                    ),
                    Positioned(
                      bottom: -MediaQuery.of(context).size.width * (0.25),
                      left: -MediaQuery.of(context).size.width * (0.25),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * (0.3)),
                          color: Colors.white54,
                        ),
                        width: MediaQuery.of(context).size.width * (0.6),
                        height: MediaQuery.of(context).size.width * (0.6),
                      ),
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width * (0.8),
                height: MediaQuery.of(context).size.height * (0.5),
                //decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0)),
              ),
            )
            /*

            Row(mainAxisAlignment: MainAxisAlignment.center, children: _buildAnswers()),
            SizedBox(
              height: 25.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (letters[currentSelectedIndex].isNotEmpty) {
                      await controllers[currentSelectedIndex].reverse();
                    }
                    setState(() {
                      letters[currentSelectedIndex] = "B";
                    });
                    controllers[currentSelectedIndex].forward();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    color: Colors.lightBlueAccent.shade100,
                    height: 50.0,
                    width: 50.0,
                    child: Center(child: Text("A")),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  color: Colors.lightBlueAccent.shade100,
                  height: 50.0,
                  width: 50.0,
                  child: Center(child: Text("A")),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  color: Colors.lightBlueAccent.shade100,
                  height: 50.0,
                  width: 50.0,
                  child: Center(child: Text("A")),
                ),
              ],
            ),
            */
          ],
        ),
      ),
    );
  }
}
