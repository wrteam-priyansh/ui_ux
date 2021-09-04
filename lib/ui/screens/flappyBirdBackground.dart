import 'dart:async';

import 'package:flutter/material.dart';

class Barrier {
  final double alignmentY;
  final double alignmentX;
  final double heightInAlignmentY;

  Barrier({required this.alignmentY, required this.heightInAlignmentY, required this.alignmentX});
}

class FlappyBirdBackground extends StatefulWidget {
  FlappyBirdBackground({Key? key}) : super(key: key);

  @override
  _FlappyBirdBackgroundState createState() => _FlappyBirdBackgroundState();
}

class _FlappyBirdBackgroundState extends State<FlappyBirdBackground> {
  final double widthInAlignment = 0.4;
  final double maxHieghtInAlignment = 0.6;
  final double borderWidthInAlignment = 0.025;

  late double firstBarrierAlignmentX = 1.0;
  final int totalBarrier = 2;

  late Timer timer;
  late double maxAlignmentX = 1.0 + ((widthInAlignment + (borderWidthInAlignment * 2)) * totalBarrier) + inBetweenBarrierAlignment;
  late double inBetweenBarrierAlignment = 1.0;
  late double alignmentDifferenceOverTime = 0.05;

  late List<Barrier> topBarrier = [];
  late List<Barrier> bottomBarrier = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startGame() {
    timer = Timer.periodic(Duration(milliseconds: 60), (timer) {
      if (firstBarrierAlignmentX <= -1.5) {
        print(firstBarrierAlignmentX + inBetweenBarrierAlignment);
        timer.cancel();
        /*
        setState(() {
          firstBarrierAlignmentX = 1.0 + widthInAlignment + (borderWidthInAlignment * 2);
        });
        */
      } else {
        setState(() {
          firstBarrierAlignmentX -= alignmentDifferenceOverTime;
        });
      }
    });
  }

  Widget _buildBarrier(int index) {
    return Align(
      alignment: Alignment(firstBarrierAlignmentX + (maxAlignmentX * index), -1.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green.shade800, width: MediaQuery.of(context).size.width * borderWidthInAlignment * (0.5)),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.green,
        ),
        width: MediaQuery.of(context).size.width * widthInAlignment * (0.5),
        height: MediaQuery.of(context).size.height * maxHieghtInAlignment * (0.5),
      ),
    );
  }

  List<Widget> _buildBarriers() {
    List<Widget> barriers = [];

    for (var i = 0; i < totalBarrier; i++) {
      barriers.add(_buildBarrier(i));
    }
    return barriers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          startGame();
          //timer.cancel();
        },
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * (0.75),
            color: Colors.blue,
            child: Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                //..._buildBarriers(),
                Align(
                  alignment: Alignment(firstBarrierAlignmentX, -1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green.shade800, width: MediaQuery.of(context).size.width * borderWidthInAlignment * (0.5)),
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.green,
                    ),
                    width: MediaQuery.of(context).size.width * widthInAlignment * (0.5),
                    height: MediaQuery.of(context).size.height * maxHieghtInAlignment * (0.5),
                  ),
                ),
                Align(
                  alignment: Alignment(firstBarrierAlignmentX + inBetweenBarrierAlignment, -1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green.shade800, width: MediaQuery.of(context).size.width * borderWidthInAlignment * (0.5)),
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.green,
                    ),
                    width: MediaQuery.of(context).size.width * widthInAlignment * (0.5),
                    height: MediaQuery.of(context).size.height * maxHieghtInAlignment * (0.5),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.brown,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * (0.25),
          ),
        ],
      ),
    );
  }
}
