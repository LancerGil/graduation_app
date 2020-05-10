import 'package:flutter/material.dart';
import 'package:graduationapp/models/stu_card.dart';

import 'selectable_item.dart';

class ChoosePage extends StatefulWidget {
  final List<StudentCard> wholeList, selectedList;

  const ChoosePage({Key key, this.wholeList, this.selectedList})
      : super(key: key);
  @override
  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget.selectedList = List();
    // widget.wholeList = StudentCard.fetchAll(LessonNow.classID);
  }

  @override
  Widget build(BuildContext context) {
    AppBar appbar = AppBar(
      title: Text(
        widget.selectedList.length < 1
            ? "选择"
            : "已选择${widget.selectedList.length} ",
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
    var body = ListView.builder(
        cacheExtent: double.infinity,
        itemCount: widget.wholeList.length,
        itemBuilder: (context, index) {
          return GridItem(
              student: widget.wholeList[index],
              isSelected: widget.selectedList.contains(widget.wholeList[index]),
              setSelected: (bool value) {
                setState(() {
                  if (value) {
                    widget.selectedList.add(widget.wholeList[index]);
                  } else {
                    widget.selectedList.remove(widget.wholeList[index]);
                  }
                });
                print("$index : $value");
              },
              key: Key(widget.wholeList[index].stuID.toString()));
        });

    return Scaffold(
      appBar: appbar,
      body: body,
    );
  }
}
