import 'package:flutter/material.dart';

class AnimatedShadowContainer extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding, margin;
  final double width, height;
  @required
  final Duration duration;
  @required
  final Curve curve;

  const AnimatedShadowContainer({
    Key key,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.child,
    this.duration,
    this.curve,
  }) : super(key: key);
  @override
  _AnimatedShadowContainerState createState() =>
      _AnimatedShadowContainerState();
}

class _AnimatedShadowContainerState extends State<AnimatedShadowContainer> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: widget.height,
      width: widget.width,
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(150),
            blurRadius: 13,
          )
        ],
      ),
      duration: widget.duration,
      curve: widget.curve,
      child: widget.child,
    );
  }
}
