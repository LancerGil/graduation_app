import 'package:flutter/material.dart';
import 'package:graduationapp/models/stu_card.dart';

import 'item_stu.dart';

class GridItem extends StatefulWidget {
  final Key key;
  final LessonStu student;
  final ValueChanged<bool> setSelected;
  bool isSelected;

  GridItem({this.student, this.setSelected, this.key, this.isSelected});

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.isSelected = !widget.isSelected;
          widget.setSelected(widget.isSelected);
        });
      },
      child: Stack(
        children: <Widget>[
          ItemStuCard(widget.student),
          widget.isSelected
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
