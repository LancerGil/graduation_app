import 'package:flutter/material.dart';
import 'package:graduationapp/models/hw_home.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/screens/home/tab_homework/item_homework.dart';

class TabHomeWork extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appbar = AppBar(
      centerTitle: true,
      title: Text(
        '课程作业',
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(letterSpacing: 1, fontWeight: FontWeight.bold),
      ),
    );
    var body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView(
        children: buildHomeworkWidgets(LessonNow.classID),
      ),
    );
    return Scaffold(appBar: appbar, body: body);
  }

  List<Widget> buildHomeworkWidgets(List hwID) {
    List<HwAtHome> hwList = HwAtHome.fetchAll(hwID);
    return hwList.map((oneHw) => ItemHomeworkNow(oneHw)).toList();
  }
}
