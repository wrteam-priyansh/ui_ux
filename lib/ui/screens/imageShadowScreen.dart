import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';

class ImageShadowScreen extends StatelessWidget {
  const ImageShadowScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 270,
                    right: MediaQuery.of(context).size.width * (0.125),
                    left: MediaQuery.of(context).size.width * (0.125),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * (0.225),
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Opacity(
                        opacity: 0.85,
                        child: Image.asset(
                          "assets/images/img8.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 260,
                  right: MediaQuery.of(context).size.width * (0.125),
                  left: MediaQuery.of(context).size.width * (0.125),
                  height: MediaQuery.of(context).size.height * (0.25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(25.0)),
                    ),
                  ),
                ),
                Positioned(
                  right: MediaQuery.of(context).size.width * (0.075),
                  left: MediaQuery.of(context).size.width * (0.075),
                  top: 250,
                  child: Container(
                    height: MediaQuery.of(context).size.height * (0.25),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/images/img8.png"))),
                  ),
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Hello",
                style: TextStyle(fontSize: 30.0),
              )),
        ],
      ),
    );
  }
}
