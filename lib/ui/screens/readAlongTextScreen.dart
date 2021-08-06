import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

String text =
    "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available.";

class ReadAlongTextScreen extends StatefulWidget {
  ReadAlongTextScreen({Key? key}) : super(key: key);

  @override
  _ReadAlongTextScreenState createState() => _ReadAlongTextScreenState();
}

class _ReadAlongTextScreenState extends State<ReadAlongTextScreen> with TickerProviderStateMixin {
  late TextSpan textSpan = TextSpan(text: text, style: TextStyle(fontSize: 30, color: Colors.redAccent, height: 1.25));

  int currentLine = -1;
  List<LineMetrics> lineMetrics = [];
  Timer? timer;
  List<AnimationController> animationControllers = [];
  final int milliseconds = 2000;

  @override
  void dispose() {
    timer?.cancel();
    animationControllers.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  void getLineMatrix() {
    final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);
    setState(() {
      lineMetrics = textPainter.computeLineMetrics();
      currentLine = 0;
      lineMetrics.forEach((element) {
        animationControllers.add(AnimationController(vsync: this, duration: Duration(milliseconds: milliseconds)));
      });
    });
    //
    animationControllers.first.forward();
    //
    timer = Timer.periodic(Duration(milliseconds: milliseconds + 150), (timer) {
      if (currentLine == (lineMetrics.length - 1)) {
        timer.cancel();
      } else {
        currentLine++;
        animationControllers[currentLine].forward();
      }
    });
  }

  Widget _buildBackgroundHighlightContainers() {
    return currentLine == -1
        ? Container()
        : Positioned(
            left: 0.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lineMetrics.map((e) {
                return AnimatedBuilder(
                  animation: animationControllers[e.lineNumber],
                  builder: (context, child) {
                    return Container(
                      height: e.height,
                      width: e.width * animationControllers[e.lineNumber].value,
                      color: Colors.black,
                    );
                  },
                );
              }).toList(),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {
          getLineMatrix();
        }),
        appBar: AppBar(
          title: Text("Read Along Text"),
        ),
        body: Stack(
          children: [
            _buildBackgroundHighlightContainers(),
            RichText(
              text: textSpan,
            ),
          ],
        ));
  }
}

class CustomTextPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(color: Colors.black, fontSize: 30);
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    //final xCenter = (size.width - textPainter.width);
    //final yCenter = (size.height - textPainter.height / 2);
    final offset = Offset(0, 0);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    throw true;
  }
}
