import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/inherited_auth.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/screens/lesson/screen_lesson.dart';

import '../search_delegate.dart';
import 'item_lesson.dart';

class TabLessonAtHome extends StatefulWidget {
  const TabLessonAtHome({Key key}) : super(key: key);

  @override
  _TabLessonAtHomeState createState() => _TabLessonAtHomeState();
}

class _TabLessonAtHomeState extends State<TabLessonAtHome> {
  TextEditingController lessonNumController;
  List lessonList;

  @override
  void initState() {
    super.initState();
    lessonList = LessonNow.fetchAll(LessonNow.classID);
    lessonNumController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    lessonNumController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('课程'),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              _handleAdd(InheritedAuth.of(context).user.identity);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.add),
            ),
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
                    lessonList, InheritedAuth.of(context).user),
              )
            },
          ),
        ),
      ),
      body: ListView(
        key: PageStorageKey("lessonScroll"),
        children: buildLessonWidgets(LessonNow.classID),
      ),
    );
  }

  List<Widget> buildLessonWidgets(List classID) {
    if (lessonList != null) {
      return lessonList.map((oneHw) => ItemLessonNow(oneHw)).toList();
    }
    return null;
  }

  _handleAdd(String identity) {
    switch (identity) {
      case "student":
        _showAddLessonDialog();
        break;
      case "teacher":
        Navigator.of(context).pushNamed('/createLesson');
        break;
      default:
    }
  }

  _showAddLessonDialog() {
    showDialog(
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('加入班级'),
          content: Container(
            height: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('输入班级码', style: Theme.of(context).textTheme.bodyText1),
                TextField(
                  controller: lessonNumController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            FlatButton(
              onPressed: () {
                String lessonNum = lessonNumController.text;
                LessonNow lesson = _searchLesson(lessonNum);
                if (lesson != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonPage(
                        lesson: lesson,
                      ),
                    ),
                  );
                } else {
                  _showLessonNotFoundDialog();
                }
              },
              child: Text('确定'),
            )
          ],
        ));
  }

  _showLessonNotFoundDialog() {
    showDialog(
        context: context,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('没有找到该课程'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('确定'),
            ),
          ],
        ));
  }

  //TODO:在后台查找是否存在该课程
  _searchLesson(lessonNum) {
    return null;
  }
}
