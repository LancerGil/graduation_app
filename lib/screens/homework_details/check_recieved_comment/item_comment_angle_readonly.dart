import 'package:flutter/material.dart';

class ItemCommentFromAngleReadOnly extends StatefulWidget {
  final int index, score;
  final String angle, content;

  ItemCommentFromAngleReadOnly({
    Key key,
    @required this.size,
    @required this.angle,
    @required this.index,
    this.score,
    this.content,
  }) : super(key: key);

  final Size size;

  @override
  _ItemCommentFromAngleReadOnlyState createState() =>
      _ItemCommentFromAngleReadOnlyState();
}

class _ItemCommentFromAngleReadOnlyState
    extends State<ItemCommentFromAngleReadOnly>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.index + 1}-${widget.angle}'),
          SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '点评：',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Spacer(),
              Text(
                '评分(1~5)：${widget.score}',
                style: Theme.of(context).textTheme.headline4,
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            widget.content,
            maxLines: null,
          ),
          Divider(),
        ],
      ),
    );
  }
}
