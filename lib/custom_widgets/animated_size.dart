import 'package:flutter/widgets.dart';

class MyAnimeSize extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const MyAnimeSize({Key key, this.child, this.duration, this.curve})
      : super(key: key);
  @override
  _MyAnimeSizeState createState() => _MyAnimeSizeState();
}

class _MyAnimeSizeState extends State<MyAnimeSize>
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
