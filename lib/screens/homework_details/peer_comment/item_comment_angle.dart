import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/shadow_container.dart';
import 'package:numberpicker/numberpicker.dart';

import 'comment_one_angle.dart';

class ItemCommentFromAngle extends StatefulWidget {
  final int index;
  final String angle, angleIntro;
  final Function updateCommentList;
  final CommentOfOneAngle commentOfOneAngle;

  ItemCommentFromAngle({
    Key key,
    @required this.size,
    this.angle,
    this.angleIntro,
    this.updateCommentList,
    this.index,
    this.commentOfOneAngle,
  }) : super(key: key);

  final Size size;

  @override
  _ItemCommentFromAngleState createState() => _ItemCommentFromAngleState();
}

class _ItemCommentFromAngleState extends State<ItemCommentFromAngle>
    with SingleTickerProviderStateMixin {
  bool _folded = true;
  Duration duration = const Duration(milliseconds: 500);
  final Curve curve = Curves.easeOutCirc;
  int score = 0;
  TextEditingController controller;

  _rate() {
    showDialog<int>(
      context: context,
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: NumberPickerDialog.integer(
            minValue: 0,
            maxValue: 5,
            initialIntegerValue: score,
          ),
        );
      },
    ).then((onValue) {
      if (onValue != null) {
        setState(() => score = onValue);
        widget.updateCommentList(widget.index, score, controller.text);
      }
    });
  }

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.commentOfOneAngle != null) {
      print('${widget.index} --widget.commentOfOneAngle != null');
      score = widget.commentOfOneAngle.score;
      controller.text = widget.commentOfOneAngle.content;
    } else
      print('${widget.index} -- widget.commentOfOneAngle == null');
    return ShadowContainer(
      width: widget.size.width,
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.angle),
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _folded = !_folded;
                  });
                },
                child: Text(
                  _folded ? '展开' : '收起',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.blue),
                ),
              )
            ],
          ),
          AnimatedSize(
            vsync: this,
            duration: duration,
            curve: curve,
            child: Text(
              widget.angleIntro,
              style: Theme.of(context).textTheme.bodyText1,
              maxLines: _folded ? 1 : null,
              overflow: TextOverflow.fade,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '点评：',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Spacer(),
              GestureDetector(
                onTap: () => _rate(),
                child: Text(
                  '评分(1~5)：$score',
                  style: Theme.of(context).textTheme.headline4,
                ),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '评语',
            ),
            maxLines: null,
            onChanged: (value) {
              widget.updateCommentList(widget.index, score, controller.text);
            },
          ),
        ],
      ),
    );
  }
}
