import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedIconButton extends StatefulWidget {
  final IconData initalIcon, anotherIcon;
  final double size;
  final Function doSomeThing;
  final bool showInitAsDefault;

  const AnimatedIconButton({
    Key key,
    this.size,
    this.initalIcon,
    this.anotherIcon,
    this.doSomeThing,
    this.showInitAsDefault,
  }) : super(key: key);
  @override
  _AnimatedIconButtonState createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool isPlaying = false, isCompleted = false;
  IconData firsIcon, secondIcon;

  @override
  void initState() {
    super.initState();
    if (!widget.showInitAsDefault) {
      firsIcon = widget.anotherIcon;
      secondIcon = widget.initalIcon;
    } else {
      firsIcon = widget.initalIcon;
      secondIcon = widget.anotherIcon;
    }
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
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
      icon: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: 1 - _controller.value * 1,
                child: Transform.rotate(
                  angle: _controller.value * math.pi,
                  child: child,
                ),
              );
            },
            child: Icon(firsIcon),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _controller.value * 1,
                child: Transform.rotate(
                  angle: math.pi - _controller.value * math.pi,
                  child: child,
                ),
              );
            },
            child: Icon(secondIcon),
          ),
        ],
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
    widget.doSomeThing();
  }
}
