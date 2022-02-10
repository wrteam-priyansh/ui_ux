import 'package:flutter/material.dart';

class ImageShadowScreen extends StatelessWidget {
  const ImageShadowScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Text("Helo"),
          //
          Padding(
            padding: EdgeInsets.only(
              top: 250,
              right: MediaQuery.of(context).size.width * (0.15),
              left: MediaQuery.of(context).size.width * (0.15),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * (0.25),
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Opacity(
                  opacity: 0.95,
                  child: Image.asset(
                    "assets/images/woman_a.jpg",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 250,
            right: MediaQuery.of(context).size.width * (0.1),
            left: MediaQuery.of(context).size.width * (0.1),
            height: MediaQuery.of(context).size.height * (0.25),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
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
                      image: AssetImage("assets/images/woman_a.jpg"))),
            ),
          ),
        ],
      ),
    );
  }
}
