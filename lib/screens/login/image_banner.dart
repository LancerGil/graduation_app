import 'package:flutter/material.dart';

class ImageBanner extends StatelessWidget {
  final String _assetPath;
  final double width, height;

  ImageBanner(this._assetPath, this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(width: width, height: height),
      child: Image.asset(
        _assetPath,
        fit: BoxFit.cover,
      ),
    );
  }
}
