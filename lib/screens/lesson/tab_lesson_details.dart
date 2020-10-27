import 'package:flutter/material.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/screens/login/image_banner.dart';

class TabLessonDetails extends StatelessWidget {
  final Lesson lesson;
  final String emptyLabel = "暂未设置";

  TabLessonDetails({Key key, this.lesson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appbar = AppBar(
      centerTitle: true,
      title: Text(
        lesson.lessonName,
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(letterSpacing: 1, fontWeight: FontWeight.bold),
      ),
    );

    var body = SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: 'lesson${lesson.lessonID}',
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withAlpha(155),
                          offset: Offset(0, 5),
                          blurRadius: 7.0)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ImageBanner(
                        'assets/images/nezuko.png',
                        MediaQuery.of(context).size.width * 0.3,
                        MediaQuery.of(context).size.width * 0.3,
                      ),
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        height: MediaQuery.of(context).size.width * 0.3,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '课程名称',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              lesson.lessonName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '教师',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    Text(
                                      lesson.lessonTea,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '课程码',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    Text(
                                      lesson.lessonID.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 1,
            ),
            Text(
              '上课时间',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Text('第 ${lesson.startWeek} - ${lesson.finishWeek}  周'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildLessonPerWeek(context),
            ),
            Divider(
              thickness: 1,
            ),
            Text(
              '课程简介',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(lesson.lessonIntro.length != 0
                  ? lesson.lessonIntro
                  : emptyLabel),
            ),
            Divider(
              thickness: 1,
            ),
            Text(
              '教学计划',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(lesson.lessonPlan.length != 0
                  ? lesson.lessonPlan
                  : emptyLabel),
            ),
            Divider(
              thickness: 1,
            ),
            Text(
              '教学目标',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(lesson.lessonTarget.length != 0
                  ? lesson.lessonTarget
                  : emptyLabel),
            ),
          ],
        ),
      ),
    );

    return Scaffold(appBar: appbar, body: body);
  }

  _buildLessonPerWeek(context) {
    return lesson.lessonsTime
        .map(
          (f) => Text(
            '     ${lesson.lessonsTime.indexOf(f) + 1}   每周${f.weekday} ' +
                f.startAt.format(context) +
                ' - ' +
                f.finishAt.format(context),
          ),
        )
        .toList();
  }
}
