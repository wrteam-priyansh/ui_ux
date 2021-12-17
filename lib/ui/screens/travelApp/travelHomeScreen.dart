import 'package:flutter/material.dart';
import 'package:ui_ux/ui/screens/travelApp/travelDetailsScreen.dart';

List<String> images = ["assets/images/image-1.png", "assets/images/image-2.png", "assets/images/image-3.png", "assets/images/image-4.png"];

class TravelHomeScreen extends StatefulWidget {
  TravelHomeScreen({Key? key}) : super(key: key);

  @override
  _TravelHomeScreenState createState() => _TravelHomeScreenState();
}

class _TravelHomeScreenState extends State<TravelHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          itemCount: images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                //
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => TravelDetailsScreen(
                          placeImage: images[index],
                        )));
              },
              child: Hero(
                tag: images[index],
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * (0.3),
                  decoration: BoxDecoration(
                    image: DecorationImage(fit: BoxFit.cover, image: AssetImage(images[index])),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 10.0,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
