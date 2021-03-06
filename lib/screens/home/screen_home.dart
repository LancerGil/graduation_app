import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/inherited_auth.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/home/tab_user_bloc/index.dart';

import 'tab_homework/tab_home_hw.dart';
import 'tab_lesson/tab_home_lesson.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var appBarTitle = ['课程', '作业', '我的'];
  TabController _tabController;
  List<int> lessonID;
  User user;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = InheritedAuth.of(context).user;
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          TabLessonAtHome(setLessonIDCallBack: setLessonIDCallBack),
          TabHWatHome(lessonID: lessonID),
          TabUserBlocPage(user: user),
        ],
      ),
      bottomNavigationBar: TabBar(
        labelPadding: EdgeInsets.zero,
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Theme.of(context).primaryColor,
        controller: _tabController,
        tabs: <Widget>[
          Tab(
            text: '课程',
            icon: Icon(CupertinoIcons.group_solid),
          ),
          Tab(
            text: '作业',
            icon: Icon(CupertinoIcons.book_solid),
          ),
          Tab(
            text: '我的',
            icon: Icon(CupertinoIcons.person_solid),
          ),
        ],
      ),
    );
  }

  setLessonIDCallBack(List<int> lessonID) {
    if (this.lessonID == null || this.lessonID.length != lessonID.length) {
      setState(() {
        this.lessonID = lessonID;
      });
      print("setting lessonID:----------${this.lessonID}");
    }
  }
}
