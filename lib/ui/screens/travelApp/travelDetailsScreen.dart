import 'package:flutter/material.dart';

class TravelDetailsScreen extends StatefulWidget {
  final String placeImage;
  TravelDetailsScreen({Key? key, required this.placeImage}) : super(key: key);

  @override
  _TravelDetailsScreenState createState() => _TravelDetailsScreenState();
}

class _TravelDetailsScreenState extends State<TravelDetailsScreen> with TickerProviderStateMixin {
  late AnimationController topButtonsAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 350));
  late Animation<double> topButtonsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(parent: topButtonsAnimationController, curve: Curves.easeInOutCubic),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //
          Align(
            alignment: Alignment.topCenter,
            child: Hero(
              tag: widget.placeImage,
              child: Container(
                height: MediaQuery.of(context).size.height * (0.475),
                decoration: BoxDecoration(
                  image: DecorationImage(fit: BoxFit.cover, image: AssetImage(widget.placeImage)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
