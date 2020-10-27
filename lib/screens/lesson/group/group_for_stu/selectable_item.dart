import 'package:flutter/material.dart';
import 'package:graduationapp/models/lesson_stu.dart';

class GridItem extends StatefulWidget {
  final Key key;
  final LessonStu student;
  final ValueChanged<bool> setSelected;
  final bool isSelected, enable;

  GridItem(
      {this.student,
      this.setSelected,
      this.key,
      this.isSelected,
      this.enable = true});

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  bool isSelected;
  @override
  void initState() {
    isSelected = widget.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.enable,
      child: InkWell(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
            widget.setSelected(isSelected);
          });
        },
        child: Container(
          color: widget.enable ? Colors.white : Colors.grey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    !widget.isSelected
                        ? Icons.panorama_fish_eye
                        : Icons.check_circle,
                    color: !widget.isSelected ? Colors.grey : Colors.blue,
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: Image.asset(
                      widget.student.stuImagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.student.stuName),
                    Text(
                      widget.student.stuNum,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
