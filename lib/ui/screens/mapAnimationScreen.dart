import 'package:flutter/material.dart';

class MapAnimationScreen extends StatefulWidget {
  MapAnimationScreen({Key? key}) : super(key: key);

  @override
  _MapAnimationScreenState createState() => _MapAnimationScreenState();
}

class _MapAnimationScreenState extends State<MapAnimationScreen> {
  late ScrollController scrollController = ScrollController();
  late List<String> images = [imagePath, imagePath, imagePath, imagePath];
  final String imagePath = "assets/images/map_finding.png";

  @override
  void initState() {
    startScrollImageAnimation();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void startScrollImageAnimation() async {
    await Future.delayed(Duration(milliseconds: 100));

    double maxScroll = scrollController.position.maxScrollExtent;

    if (maxScroll == 0) {
      startScrollImageAnimation();
    }
    scrollController.animateTo(maxScroll, duration: Duration(milliseconds: 4000), curve: Curves.linear);

/*
    await Future.delayed(Duration(milliseconds: 1990));
    if (mounted) {
      setState(() {
        images.add(imagePath);
      });
      startScrollImageAnimation();
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }),
      body: SafeArea(
        child: Stack(
          children: [
            //Center(child: Image.asset(imagePath)),
            SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * (0.7),
                child: Row(
                  children: images
                      .map((e) => Image.asset(
                            e,
                          ))
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
