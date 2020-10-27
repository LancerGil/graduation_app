import 'package:flutter/widgets.dart';

class MyAnimatedSize extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const MyAnimatedSize({Key key, this.child, this.duration, this.curve})
      : super(key: key);
  @override
  _MyAnimatedSizeState createState() => _MyAnimatedSizeState();
}

class _MyAnimatedSizeState extends State<MyAnimatedSize>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: widget.duration,
      vsync: this,
      curve: widget.curve,
      child: widget.child,
    );
  }
}
