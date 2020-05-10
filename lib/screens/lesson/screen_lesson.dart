import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/inherited_auth.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/lesson/tab_lesson_hw.dart';
import 'package:graduationapp/screens/lesson/tab_lesson_details.dart';
import 'package:graduationapp/screens/lesson/tab_lesson_members.dart';

import 'group/group_for_stu/tab_group_stu.dart';
import 'group/group_for_tea/tab_group_tea.dart';

class LessonPage extends StatefulWidget {
  final LessonNow lesson;
  final User user;

  const LessonPage({Key key, this.lesson, this.user}) : super(key: key);

  @override
  _LessonPageState createState() => _LessonPageState(lesson);
}

class _LessonPageState extends State<LessonPage>
    with SingleTickerProviderStateMixin {
  var classID = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final LessonNow lesson;
  TabController _controller;
  static const int EDIT_FROM_TEA = 6;
  List<String> tabTitles = ['课程详情', '作业记录', '小组', '课程成员'];
  List<IconData> tabIcons = [
    Icons.school,
    Icons.library_books,
    Icons.group,
    Icons.contacts
  ];

  _LessonPageState(this.lesson);

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //TODO: 实现菜单功能
  _onMenuSelected(value) {
    switch (value) {
      case EDIT_FROM_TEA:
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    var body = TabBarView(
      controller: _controller,
      children: <Widget>[
        TabLessonDetails(lesson: lesson),
        TabHomeWork(),
        widget.user.identity == "student" ? TabGroupForStu() : TabGroupForTea(),
        TabLessonMenmbers(),
      ],
    );
    var bottomNavigationBar = TabBar(
      unselectedLabelColor: Colors.grey,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: Theme.of(context).primaryColor,
      controller: _controller,
      tabs: _buildTabs(),
    );

    return Scaffold(
      body: InheritedAuth(user: widget.user, child: body),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  _buildTabs() {
    return tabTitles
        .map(
          (f) => Tab(
            icon: Icon(
              tabIcons[tabTitles.indexOf(f)],
            ),
            text: f,
          ),
        )
        .toList();
  }
}
