import 'dart:async';

import 'package:flutter/material.dart';

class TempScreen extends StatefulWidget {
  TempScreen({Key? key}) : super(key: key);

  @override
  _TempScreenState createState() => _TempScreenState();
}

class _TempScreenState extends State<TempScreen> {
  Alignment alignment = Alignment(0.0, 0.0);
  late Timer timer;

  void startTimer() {
    timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (alignment.x > 1.0) {
        setState(() {
          alignment = Alignment(-1.0, 1.0);
        });
      } else {
        setState(() {
          alignment = Alignment(0.05 + alignment.x, -0.05 + alignment.y);
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        startTimer();
      }),
      body: Stack(
        children: [
          Align(
            alignment: alignment,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
          /*
          Align(
            child: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
            ),
            alignment: Alignment(-0.5, 0.0),
          ),
          */
        ],
      ),
    );
  }
}
