import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ui_ux/convertNumber.dart';

class RandomWalker extends StatefulWidget {
  RandomWalker({Key? key}) : super(key: key);

  @override
  _RandomWalkerState createState() => _RandomWalkerState();
}

class _RandomWalkerState extends State<RandomWalker> {
  late List<Alignment> alignments = [Alignment(0, 0)];
  Timer? timer;
  late Random random = Random();

  @override
  void initState() {
    initRandomWalk();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void initRandomWalk() {
    timer = Timer.periodic(Duration(milliseconds: 17), (timer) {
      int direction = random.nextInt(4);

      Alignment previous = alignments[alignments.length - 1];
      if (direction == 0) {
        alignments.add(Alignment(previous.x - 0.025, previous.y));
      } else if (direction == 1) {
        alignments.add(Alignment(previous.x + 0.025, previous.y));
      } else if (direction == 2) {
        alignments.add(Alignment(previous.x, previous.y - 0.025));
      } else if (direction == 3) {
        alignments.add(Alignment(previous.x, previous.y + 0.025));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          ...alignments
              .map((e) => Align(
                    alignment: e,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 2.5,
                    ),
                  ))
              .toList()
        ],
      ),
    );
  }
}
