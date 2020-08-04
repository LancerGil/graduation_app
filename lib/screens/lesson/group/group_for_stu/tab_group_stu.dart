import 'package:flutter/material.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/models/stu_card.dart';

import 'dialog_create_group.dart';
import 'item_stu.dart';

class TabGroupForStu extends StatefulWidget {
  @override
  _TabGroupForStuState createState() => _TabGroupForStuState();
}

class _TabGroupForStuState extends State<TabGroupForStu> {
  static const int EXIT_GROUP = 2;
  static const int CREATE_GROUP = 3;
  static const int JOIN_GROUP = 4;
  static const int EDIT_GROUP = 5;

  List<LessonStu> groupMem;
  String groupName;

  @override
  void initState() {
    super.initState();
    groupMem = LessonStu.fetchAll([1, 2, 3, 4]);
    groupName = 'dfadfsd';
    // groupName.write('objfdd');
  }

  @override
  Widget build(BuildContext context) {
    var appbar = AppBar(
      centerTitle: true,
      title: Text(
        '小组-$groupName',
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(letterSpacing: 1, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        PopupMenuButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.grey,
          ),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                enabled: groupMem.isEmpty,
                value: CREATE_GROUP,
                child: Text('创建小组'),
              ),
              PopupMenuItem(
                value: EDIT_GROUP,
                child: Text('编辑小组'),
              ),
            ];
          },
          onSelected: (_) {
            _onMenuSelected(_);
          },
        ),
      ],
    );
    var body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView(
        children: buildStudentWidgets(Lesson.classID),
      ),
    );
    return Scaffold(appBar: appbar, body: body);
  }

  List<Widget> buildStudentWidgets(List hwID) {
    return groupMem.map((oneStu) => ItemStuCard(oneStu)).toList();
  }

  _onMenuSelected(value) {
    switch (value) {
      case CREATE_GROUP:
        showManageGroupDialog('创建小组');
        break;
      case EDIT_GROUP:
        showManageGroupDialog('编辑小组');
        break;
      case JOIN_GROUP:
        break;
      case EXIT_GROUP:
        break;
      default:
    }
  }

  showManageGroupDialog(title) {
    showDialog<List<LessonStu>>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(title),
            content: DialogCreatGroup(
              memberList: groupMem,
              groupName: groupName,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('完成'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }).then((onValue) {
      if (onValue != groupMem && onValue != null) {
        print(onValue);
        setState(() => groupMem = onValue);
      }
    });
  }
}
