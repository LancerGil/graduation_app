import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding, margin;
  final double width, height, radius;
  final Color color;

  const ShadowContainer(
      {Key key,
      this.child,
      this.padding,
      this.margin,
      this.width,
      this.height,
      this.color = Colors.white,
      this.radius = 16})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(150),
            blurRadius: 13,
          )
        ],
      ),
      child: child,
    );
  }
}
