import 'package:flutter/material.dart';

class TapAnimationScreen extends StatefulWidget {
  TapAnimationScreen({Key? key}) : super(key: key);

  @override
  _TapAnimationScreenState createState() => _TapAnimationScreenState();
}

class _TapAnimationScreenState extends State<TapAnimationScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tap Animation")),
      body: Container(),
    );
  }
}
