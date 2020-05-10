import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/inherited_auth.dart';
import 'package:graduationapp/models/hw_home.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/home/search_delegate.dart';

import 'item_homework.dart';

class TabHWatHome extends StatefulWidget {
  @override
  _TabHWatHomeState createState() => _TabHWatHomeState();
}

class _TabHWatHomeState extends State<TabHWatHome> {
  List hwList;
  String identity;

  @override
  void initState() {
    super.initState();
    hwList = HwAtHome.fetchAll(LessonNow.classID);
  }

  @override
  Widget build(BuildContext context) {
    User user = InheritedAuth.of(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('作业'),
        centerTitle: true,
        actions: <Widget>[
          Visibility(
            visible: user.identity == "teacher",
            child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.grey,
                ),
                onPressed: () {
                  identity == "teacher"
                      ? Navigator.of(context).pushNamed('/createHw')
                      : Navigator.of(context).pushNamed('/hwFromTea');
                }),
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            onPressed: () => {
              showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(
                      hwList, InheritedAuth.of(context).user))
            },
          ),
        ),
      ),
      body: ListView(
        key: PageStorageKey("hwScroll"),
        children: buildHomeworkWidgets(),
      ),
    );
  }

  List<Widget> buildHomeworkWidgets() {
    if (hwList != null) {
      return hwList.map((oneHw) => ItemHomeworkNow(oneHw)).toList();
    }
    return null;
  }
}
