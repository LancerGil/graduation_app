import 'package:flutter/material.dart';
import 'package:graduationapp/models/hw_question.dart';

class ItemHWQuestion extends StatefulWidget {
  final HWQuestion question;

  const ItemHWQuestion({Key key, this.question}) : super(key: key);

  @override
  _ItemHWQuestionState createState() => _ItemHWQuestionState();
}

class _ItemHWQuestionState extends State<ItemHWQuestion>
    with SingleTickerProviderStateMixin {
  Duration _duration = Duration(milliseconds: 500);
  Curve _curve = Curves.easeOutCirc;

  bool _folded = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: _duration,
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.80,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withAlpha(155),
              offset: Offset(0, 0),
              blurRadius: 16.0)
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      child: AnimatedSize(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '20161003441',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
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
                        .bodyText2
                        .copyWith(color: Colors.blue),
                  ),
                ),
              ],
            ),
            Text(
              widget.question.question,
              maxLines: _folded ? 2 : null,
              overflow: _folded ? TextOverflow.ellipsis : null,
            ),
            Text(
              '教师回复：',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              widget.question.question,
              maxLines: _folded ? 2 : null,
              overflow: _folded ? TextOverflow.ellipsis : null,
            ),
          ],
        ),
        duration: _duration,
        vsync: this,
        curve: _curve,
      ),
    );
  }
}
