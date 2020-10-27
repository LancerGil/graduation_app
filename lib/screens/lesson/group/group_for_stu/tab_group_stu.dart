import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/models/lesson_stu.dart';
import 'package:graduationapp/models/stu_group.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/utils/firebase_store.dart';
import 'package:graduationapp/utils/flutter_toast.dart';

import 'dialog_create_group.dart';
import 'item_stu.dart';

class TabGroupForStu extends StatefulWidget {
  final List<LessonStu> members;
  final Lesson lesson;
  final User user;
  final Function updateGroupInfo;

  const TabGroupForStu(
      {Key key, this.members, this.lesson, this.user, this.updateGroupInfo})
      : super(key: key);

  @override
  _TabGroupForStuState createState() => _TabGroupForStuState();
}

class _TabGroupForStuState extends State<TabGroupForStu> {
  static const int EXIT_GROUP = 2;
  static const int CREATE_GROUP = 3;
  static const int JOIN_GROUP = 4;
  static const int EDIT_GROUP = 5;

  List<LessonStu> groupMem = [], originalGroupMem = [];
  List<StuGroup> allGroups = [];
  String groupName;
  User user;
  StuGroup ourGroup;
  bool checkingDB = true;
  FireBaseStore fireBaseStore;

  @override
  void initState() {
    super.initState();
    fireBaseStore = FireBaseStore();

    user = widget.user;
    if (widget.members != null && widget.members.isNotEmpty) {
      groupMem.add(
        widget.members.firstWhere(
          (element) => element.stuNum == user.stuID,
          orElse: null,
        ),
      );
    }
    // if (groupMem.first.groupID == 'undecided') {
    // checkingDB = false;
    // } else
    _initialData();
  }

  _initialData() async {
    QuerySnapshot querySnapshot = await fireBaseStore.queryDocuments(
      'group',
      MapEntry('lessonID', widget.lesson.lessonID),
    );
    if (querySnapshot.documents != null && querySnapshot.documents.isNotEmpty) {
      for (var eachGroupSnapshot in querySnapshot.documents) {
        allGroups.add(
          StuGroup.fromSnapshot(eachGroupSnapshot),
        );
      }

      List query = allGroups
          .where((element) => element.memberUserIDs.contains(user.userId))
          .toList();

      if (query.isNotEmpty) {
        ourGroup = query.first;
        groupName = ourGroup.groupName;
        initMemberSelected();
      }
    }
    checkingDB = false;

    if (this.mounted) {
      setState(() {});
    }
  }

  initMemberSelected() {
    groupMem.clear();

    for (var userID in ourGroup.memberUserIDs) {
      LessonStu lessonStu = widget.members.firstWhere(
        (element) => element.stuID == userID,
        orElse: null,
      );
      groupMem.add(lessonStu);
      originalGroupMem.add(lessonStu);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(groupMem);
    var appbar = AppBar(
      centerTitle: true,
      title: Text(
        groupName == null ? '小组' : '小组 - $groupName',
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
                enabled: groupName == null,
                value: CREATE_GROUP,
                child: Text('创建小组'),
              ),
              PopupMenuItem(
                enabled: groupName != null,
                value: EDIT_GROUP,
                child: Text('编辑小组'),
              ),
            ];
          },
          onSelected: (_) {
            _onMenuSelected(context, _);
          },
        ),
      ],
    );
    var body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: checkingDB
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: buildStudentWidgets(),
            ),
    );
    return Scaffold(appBar: appbar, body: body);
  }

  updateGroupInfo(String groupName, List<LessonStu> groupMem) {
    print('updating group info : $groupName -- $groupMem');
    setState(() {
      this.groupName = groupName;
      this.groupMem = groupMem;
    });
  }

  updateGroupToDB(int option) {
    List<String> memberUserIDs = [];
    groupMem.forEach((e) {
      memberUserIDs.add(e.stuID);
    });
    StuGroup stuGroup = StuGroup(
      lessonID: widget.lesson.lessonID,
      groupID: ourGroup?.groupID,
      groupName: groupName,
      memberUserIDs: memberUserIDs,
    );

    switch (option) {
      case CREATE_GROUP:
        fireBaseStore.addDocument('group', stuGroup.toJson());
        MyFlutterToast.showToast('创建成功', context);

        break;
      case EDIT_GROUP:
        fireBaseStore.updateDocument(
            'group', ourGroup.groupID, stuGroup.toJson());
        for (var member in originalGroupMem) {
          if (groupMem.contains(member)) {
            print('contains---${member.stuName}');
          } else {
            print('not contains---${member.stuName}');
            fireBaseStore.updateDocument(
              'lesson_stu',
              member.docID,
              {'groupID': 'undecided'},
            );
          }
        }
        MyFlutterToast.showToast('编辑成功', context);
        break;
      default:
    }
    widget.updateGroupInfo(groupMem, groupName);
  }

  List<Widget> buildStudentWidgets() {
    return groupMem.map((oneStu) => ItemStuCard(oneStu)).toList();
  }

  _onMenuSelected(context, value) {
    switch (value) {
      case CREATE_GROUP:
        showManageGroupDialog(context, '创建小组', CREATE_GROUP);
        break;
      case EDIT_GROUP:
        showManageGroupDialog(context, '编辑小组', EDIT_GROUP);
        break;
      case JOIN_GROUP:
        break;
      case EXIT_GROUP:
        break;
      default:
    }
  }

  void showManageGroupDialog(context, String title, int option) {
    showDialog<MapEntry<String, List<LessonStu>>>(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(10),
            scrollable: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(title),
            content: DialogCreatGroup(
              wholeList: widget.members,
              memberList: groupMem,
              groupName: groupName,
              updateGroupMemList: updateGroupInfo,
              stuID: user.stuID,
              groupID: ourGroup?.groupID,
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
                  Navigator.of(context).pop(MapEntry(groupName, groupMem));
                },
              )
            ],
          );
        }).then((onValue) {
      if (onValue != null) {
        print('编辑小组返回结果----$onValue');
        // updateGroupInfo(onValue.key, onValue.value);
        updateGroupToDB(option);
      } else {
        print('编辑小组返回结果----$onValue');
      }
    });
  }
}
