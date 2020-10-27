import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  const CircleImage({
    Key key,
    this.height,
    this.width,
    this.imageUrl,
  }) : super(key: key);

  final double height, width;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withAlpha(150),
              offset: Offset(0, height / 10),
              blurRadius: height / 8)
        ],
        border: Border.all(width: height / 26, color: Colors.white),
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(imageUrl),
        ),
      ),
    );
  }
}
