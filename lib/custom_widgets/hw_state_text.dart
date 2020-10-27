import 'package:flutter/material.dart';

class HwStateText extends StatelessWidget {
  final List<String> _hWStateCN = [
    '无互评作业',
    '一稿阶段',
    '一评阶段',
    '二稿阶段',
    '二评阶段',
    '师评阶段',
    '已结束',
  ];

  final List<Color> _hWStateColor = [
    Colors.black54,
    Colors.redAccent,
    Colors.deepOrangeAccent,
    Colors.orangeAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.grey
  ];

  final int hwState;

  HwStateText({Key key, this.hwState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        _hWStateCN[hwState],
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(color: _hWStateColor[hwState]),
      ),
    );
  }
}
