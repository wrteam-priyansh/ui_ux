import 'package:flutter/material.dart';

class CircularButtonContainer extends StatelessWidget {
  final Color? backgroundColor;
  final Function onTap;
  final IconData iconData;
  final Color? iconColor;
  final double? iconSize;
  final double? buttonRadius;
  const CircularButtonContainer(
      {Key? key,
      this.backgroundColor,
      this.iconColor,
      this.buttonRadius,
      this.iconSize,
      required this.iconData,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        this.onTap();
      },
      child: CircleAvatar(
        backgroundColor: this.backgroundColor ?? Colors.black,
        child: Icon(
          this.iconData,
          color: this.iconColor ?? Colors.white,
          size: this.iconSize ?? 40.0,
        ),
        radius: this.buttonRadius ?? 30.0,
      ),
    );
  }
}
