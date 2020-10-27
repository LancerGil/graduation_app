import 'package:flutter/material.dart';
import 'package:graduationapp/models/lesson_stu.dart';

import 'selectable_item.dart';

class ChoosePage extends StatefulWidget {
  final String thisGroupID;
  final List<LessonStu> wholeList, selectedList;

  const ChoosePage(
      {Key key, this.wholeList, this.selectedList, this.thisGroupID})
      : super(key: key);
  @override
  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  List<LessonStu> originalSelected;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget.wholeList = StudentCard.fetchAll(LessonNow.classID);
  }

  @override
  Widget build(BuildContext context) {
    AppBar appbar = AppBar(
      title: Text(
        widget.selectedList.length < 1
            ? "选择"
            : "已选择${widget.selectedList.length - 1} ",
      ),
      centerTitle: true,
      actions: <Widget>[
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.check,
              color: Colors.greenAccent,
            ),
          ),
          onTap: () {
            Navigator.pop(context, widget.selectedList);
          },
        )
      ],
    );

    var body = Container(
      color: Colors.white,
      child: ListView.builder(
          cacheExtent: double.infinity,
          itemCount: widget.wholeList.length,
          itemBuilder: (context, index) {
            return GridItem(
              // enable: widget.selectedList.contains(widget.wholeList[index]),
              enable: ifEnable(index),
              student: widget.wholeList[index],
              isSelected: isInSeletedList(index),
              setSelected: (bool value) {
                setState(() {
                  if (value) {
                    widget.selectedList.add(widget.wholeList[index]);
                  } else {
                    widget.selectedList.removeWhere((value) =>
                        value.stuID == widget.wholeList[index].stuID);
                  }
                });
                print("$index : $value");
              },
              key: Key(
                widget.wholeList[index].stuID.toString(),
              ),
            );
          }),
    );

    return Scaffold(
      appBar: appbar,
      body: body,
    );
  }

  bool isInSeletedList(int index) {
    return widget.selectedList
        .where((value) => value.stuID == widget.wholeList[index].stuID)
        .isNotEmpty;
  }

  bool isInGroupNow(index) {
    return widget.wholeList[index].groupID == widget.thisGroupID;
  }

  bool ifEnable(int index) {
    if (isInSeletedList(index)) return true;
    if (widget.selectedList.length < 4 &&
        (widget.wholeList[index].groupID == 'undecided' || isInGroupNow(index)))
      return true;
    else
      return false;
  }
}
