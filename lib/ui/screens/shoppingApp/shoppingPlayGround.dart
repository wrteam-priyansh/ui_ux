import 'package:flutter/material.dart';

class ShoppingPlayGround extends StatefulWidget {
  final String imageUrl;
  ShoppingPlayGround({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _ShoppingPlayGroundState createState() => _ShoppingPlayGroundState();
}

class _ShoppingPlayGroundState extends State<ShoppingPlayGround> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //
          Hero(
            tag: widget.imageUrl,
            child: Container(
              height: MediaQuery.of(context).size.height * (0.7),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(25.0)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(widget.imageUrl),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
