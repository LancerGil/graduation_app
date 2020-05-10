import 'package:flutter/material.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/models/stu_card.dart';

import 'group/group_for_stu/item_stu.dart';

class TabLessonMenmbers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appbar = AppBar(
      centerTitle: true,
      title: Text(
        '课程成员',
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(letterSpacing: 1, fontWeight: FontWeight.bold),
      ),
    );
    var body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView(
        children: buildStudentWidgets(LessonNow.classID),
      ),
    );
    return Scaffold(appBar: appbar, body: body);
  }

  List<Widget> buildStudentWidgets(List hwID) {
    List<StudentCard> hwList = StudentCard.fetchAll(hwID);
    return hwList.map((oneStu) => ItemStuCard(oneStu)).toList();
  }
}
