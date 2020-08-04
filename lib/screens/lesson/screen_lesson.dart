import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/inherited_auth.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/models/stu_card.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/lesson/tab_lesson_hw.dart';
import 'package:graduationapp/screens/lesson/tab_lesson_details.dart';
import 'package:graduationapp/screens/lesson/tab_lesson_members.dart';
import 'package:graduationapp/utils/firebase_store.dart';

import 'group/group_for_stu/tab_group_stu.dart';
import 'group/group_for_tea/tab_group_tea.dart';

class LessonPage extends StatefulWidget {
  final Lesson lesson;
  final User user;

  const LessonPage({Key key, this.lesson, this.user}) : super(key: key);

  @override
  _LessonPageState createState() => _LessonPageState(lesson);
}

class _LessonPageState extends State<LessonPage>
    with SingleTickerProviderStateMixin {
  final Lesson lesson;
  TabController _controller;
  static const int EDIT_FROM_TEA = 6;
  List<String> tabTitles = ['课程详情', '作业记录', '小组', '课程成员'];
  List<IconData> tabIcons = [
    Icons.school,
    Icons.library_books,
    Icons.group,
    Icons.contacts
  ];

  BaseFireBaseStore fireBaseStore;
  List<LessonStu> members;

  _LessonPageState(this.lesson);

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
    fireBaseStore = FireBaseStore();
    _getLessonMember(lesson);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var body = TabBarView(
      controller: _controller,
      children: <Widget>[
        TabLessonDetails(lesson: lesson),
        TabHomeWork(currentLesson: lesson),
        widget.user.identity == "student" ? TabGroupForStu() : TabGroupForTea(),
        TabLessonMenmbers(
          membersList: members,
        ),
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

  _getLessonMember(Lesson lesson) async {
    members = new List();
    List<DocumentSnapshot> listLessonStu;

    listLessonStu = await fireBaseStore
        .queryDocuments('lesson_stu', MapEntry('lessonID', lesson.lessonID))
        .then((value) => value.documents);
    print(listLessonStu);

    if (this.mounted) {
      setState(() {
        members = listLessonStu.map((e) => LessonStu.fromDoc(e)).toList();
      });
    }
  }
}
