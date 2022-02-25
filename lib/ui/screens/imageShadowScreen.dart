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
          ImageShadowContainer(
            imageHeight: MediaQuery.of(context).size.height * (0.3),
            imageWidth: MediaQuery.of(context).size.width,
            imageUrl: "assets/images/dailyLesson-3.jpg",
          ),
          SizedBox(
            height: 100.0,
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

class ImageShadowContainer extends StatelessWidget {
  final double imageWidth;
  final double imageHeight;
  final String imageUrl;
  final double? backgroundImageOpacity;
  final double? shadowTopPadding;
  final double? imageHorizontalMarginPercentage;
  final double? topMargin;
  final double? bottomMargin;
  final double? borderRadius;
  final double? blurEffect;
  const ImageShadowContainer({
    this.backgroundImageOpacity,
    required this.imageHeight,
    required this.imageUrl,
    required this.imageWidth,
    this.shadowTopPadding,
    this.imageHorizontalMarginPercentage,
    this.topMargin,
    this.bottomMargin,
    this.borderRadius,
    this.blurEffect,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(top: topMargin ?? 25.0, bottom: bottomMargin ?? 0),
      height: imageHeight,
      width: imageWidth,
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: shadowTopPadding ?? (40),
                right: boxConstraints.maxWidth *
                    (imageHorizontalMarginPercentage == null
                        ? 0.125
                        : (imageHorizontalMarginPercentage! + 0.05)),
                left: boxConstraints.maxWidth *
                    (imageHorizontalMarginPercentage == null
                        ? 0.125
                        : (imageHorizontalMarginPercentage! + 0.05)),
              ),
              child: SizedBox(
                height: boxConstraints.maxHeight,
                width: boxConstraints.maxWidth,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius ?? 25),
                  child: Opacity(
                    opacity: backgroundImageOpacity ?? 1.0,
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: shadowTopPadding == null ? 30 : (shadowTopPadding! - 10),
              right: boxConstraints.maxWidth *
                  (imageHorizontalMarginPercentage == null
                      ? 0.125
                      : (imageHorizontalMarginPercentage! + 0.05)),
              left: boxConstraints.maxWidth *
                  (imageHorizontalMarginPercentage == null
                      ? 0.125
                      : (imageHorizontalMarginPercentage! + 0.05)),
              height: boxConstraints.maxHeight,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: blurEffect ?? 25.0, sigmaY: blurEffect ?? 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(borderRadius ?? 25)),
                ),
              ),
            ),
            Positioned(
              left: boxConstraints.maxWidth *
                  (imageHorizontalMarginPercentage ?? 0.075),
              right: boxConstraints.maxWidth *
                  (imageHorizontalMarginPercentage ?? 0.075),
              child: Container(
                height: boxConstraints.maxHeight,
                width: boxConstraints.maxWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius ?? 25),
                    image: DecorationImage(
                        fit: BoxFit.cover, image: AssetImage(imageUrl))),
              ),
            ),
          ],
        );
      }),
    );
  }
}
