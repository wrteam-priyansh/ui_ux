import 'package:flutter/material.dart';
import 'package:ui_ux/ui/screens/blurhHashImageScreen.dart';
import 'package:ui_ux/ui/screens/curveScreen.dart';
import 'package:ui_ux/ui/screens/innerScrollingImageSlider.dart';
import 'package:ui_ux/ui/screens/lottieScreen.dart';
import 'package:ui_ux/ui/screens/mapAnimationScreen.dart';
import 'package:ui_ux/ui/screens/quizPlayAreaScreen.dart';
import 'package:ui_ux/ui/screens/readAlongTextScreen.dart';
import 'package:ui_ux/ui/screens/scrollDragAnimationScreen.dart';
import 'package:ui_ux/ui/screens/selectWordAnimationScreen.dart';
import 'package:ui_ux/ui/screens/tapAnimationScreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> examples = ["Quiz Play Area", "Scroll Drag Animation", "Select Word Animation", "Tap Animation", "Map Animation", "Blur Hash Image", "Read Along Text", "Lottie Screen", "Inner Scrolling Image Slider(AJIO)", "Curve"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              if (examples[index] == "Quiz Play Area") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => QuizPlayAreaScreen()));
              } else if (examples[index] == "Scroll Drag Animation") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ScrollDragAnimationScreen()));
              } else if (examples[index] == "Select Word Animation") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SelectWordAnimationScreen()));
              } else if (examples[index] == "Tap Animation") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TapAnimationScreen()));
              } else if (examples[index] == "Map Animation") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MapAnimationScreen()));
              } else if (examples[index] == "Blur Hash Image") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BlurHashImageScreen()));
              } else if (examples[index] == "Read Along Text") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReadAlongTextScreen()));
              } else if (examples[index] == "Lottie Screen") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LottieScreen()));
              } else if (examples[index] == "Inner Scrolling Image Slider(AJIO)") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InnerScrollingImageSliderScreen(
                              screenSize: MediaQuery.of(context).size,
                            )));
              } else if (examples[index] == "Curve") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CurveScreen()));
              }
              //
            },
            title: Text("${examples[index]}"),
          );
        },
        itemCount: examples.length,
      ),
      appBar: AppBar(
        title: Text("UI - UX"),
      ),
    );
  }
}
