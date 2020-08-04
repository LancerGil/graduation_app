import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/loading_card.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/models/stu_card.dart';

import 'group/group_for_stu/item_stu.dart';

class TabLessonMenmbers extends StatefulWidget {
  final List<LessonStu> membersList;

  const TabLessonMenmbers({Key key, this.membersList}) : super(key: key);

  @override
  _TabLessonMenmbersState createState() => _TabLessonMenmbersState();
}

class _TabLessonMenmbersState extends State<TabLessonMenmbers>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('课程成员--build--${widget.membersList}');

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
        children: widget.membersList == null
            ? _showLoadingAnimation()
            : buildStudentWidgets(Lesson.classID),
      ),
    );
    return Scaffold(appBar: appbar, body: body);
  }

  _showLoadingAnimation() {
    return Lesson.classID
        .map((e) => LoadingCard(controller: _controller))
        .toList();
  }

  List<Widget> buildStudentWidgets(List hwID) {
    return widget.membersList.map((oneStu) => ItemStuCard(oneStu)).toList();
  }
}
