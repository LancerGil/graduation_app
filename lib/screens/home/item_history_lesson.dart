import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/inherited_auth.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/lesson/screen_lesson.dart';

class HistoryLesson extends StatelessWidget {
  final Lesson lesson;

  const HistoryLesson(this.lesson);

  @override
  Widget build(BuildContext context) {
    final lessonID = lesson.lessonID;
    User user = InheritedAuth.of(context).user;

    return Hero(
      tag: 'lesson$lessonID',
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      LessonPage(user: user, lesson: lesson)));
        },
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 8.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        height: 110,
                        child: Image.asset(
                          lesson.lessonImagePath,
                          fit: BoxFit.cover,
                        )),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Container(
                        child: Text(
                          lesson.lessonName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 12.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 3,
            )
          ],
        ),
      ),
    );
  }
}
