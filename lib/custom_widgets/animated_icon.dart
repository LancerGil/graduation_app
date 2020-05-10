import 'package:flutter/material.dart';

class AnimeIconButton extends StatefulWidget {
  final AnimatedIconData animatedIcons;
  final double size;

  const AnimeIconButton({Key key, this.animatedIcons, this.size})
      : super(key: key);
  @override
  _AnimeIconButtonState createState() => _AnimeIconButtonState();
}

class _AnimeIconButtonState extends State<AnimeIconButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool isPlaying = false, isCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: widget.size,
      icon: AnimatedIcon(
        icon: widget.animatedIcons,
        progress: _controller,
      ),
      onPressed: () => _handleAnime(),
    );
  }

  _handleAnime() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }
}
