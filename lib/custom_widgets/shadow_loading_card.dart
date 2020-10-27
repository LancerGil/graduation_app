import 'package:flutter/material.dart';

class LoadingCard extends StatefulWidget {
  final AnimationController controller;

  const LoadingCard({Key key, this.controller}) : super(key: key);
  @override
  _LoadingCardState createState() => _LoadingCardState();
}

class _LoadingCardState extends State<LoadingCard> {
  Animation _animeLeft, _animeRight;

  @override
  void initState() {
    super.initState();
    _animeLeft = ColorTween(begin: Colors.grey, end: Colors.grey.shade100)
        .animate(widget.controller);
    _animeRight = ColorTween(begin: Colors.grey.shade100, end: Colors.grey)
        .animate(widget.controller);
    widget.controller.addListener(() {
      if (widget.controller.status == AnimationStatus.completed)
        widget.controller.reverse();
      else if (widget.controller.status == AnimationStatus.dismissed)
        widget.controller.forward();
      setState(() {});
    });
    widget.controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(colors: [_animeLeft.value, _animeRight.value])
              .createShader(bounds);
          // return LinearGradient(colors: [Colors.grey, Colors.grey.shade100])
          //     .createShader(bounds);
        },
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 100,
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 10,
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 10,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
