import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/index.dart';
import 'package:graduationapp/models/index.dart';
import 'package:graduationapp/models/lesson_time.dart';
import 'package:graduationapp/screens/home/tab_lesson/screen_create_lesson/item_lesson_time.dart';
import 'package:numberpicker/numberpicker.dart';

class BodyCreateHomework extends StatelessWidget {
  const BodyCreateHomework({
    Key key,
    @required this.lessonNameCon,
    @required this.lessonCreating,
    @required this.startAtWeek,
    @required this.finishAtWeek,
    @required StreamController<List<LessonTime>> events,
    @required this.lessonIntroCon,
    @required this.lessonTargetCon,
    @required this.lessonPlanCon,
    @required updateLessonCreatingModel,
    @required incrementLessonPerWeek,
    @required deleteLessonPerWeek,
    @required updateLessonPerWeek,
  })  : _events = events,
        _updateLessonCreatingModel = updateLessonCreatingModel,
        _incrementLessonPerWeek = incrementLessonPerWeek,
        _deleteLessonPerWeek = deleteLessonPerWeek,
        _updateLessonPerWeek = updateLessonPerWeek,
        super(key: key);

  final TextEditingController lessonNameCon;
  final Lesson lessonCreating;
  final int startAtWeek;
  final int finishAtWeek;
  final StreamController<List<LessonTime>> _events;
  final TextEditingController lessonIntroCon;
  final TextEditingController lessonTargetCon;
  final TextEditingController lessonPlanCon;
  final Function _updateLessonCreatingModel,
      _incrementLessonPerWeek,
      _deleteLessonPerWeek,
      _updateLessonPerWeek;

  _showWeekPicker(context, min, max, intial) {
    showDialog<int>(
      context: context,
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: new NumberPickerDialog.integer(
            title: Text(
              '设置开课区间',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
            minValue: min,
            maxValue: max,
            initialIntegerValue: intial,
          ),
        );
      },
    ).then((onValue) {
      if (onValue != null) {
        if (max != 25) {
          lessonCreating.startWeek = onValue;
          _updateLessonCreatingModel(context);
        } else {
          lessonCreating.finishWeek = onValue;
          _updateLessonCreatingModel(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: lessonNameCon,
              onChanged: (text) {
                lessonCreating.lessonName = text;
                _updateLessonCreatingModel(context);
              },
              style: Theme.of(context).textTheme.bodyText2,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: '课程名称'),
            ),
            SizedBox(height: 10),
            Divider(),
            Text(
              '上课时间',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(height: 5),
            Row(
              children: <Widget>[
                Text('开课区间：'),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    _showWeekPicker(context, 1, 24, startAtWeek);
                  },
                  child: Text(
                    '第 $startAtWeek 周',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Text(' — '),
                GestureDetector(
                  onTap: () {
                    _showWeekPicker(context, startAtWeek, 25, startAtWeek);
                  },
                  child: Text(
                    '第 $finishAtWeek 周',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '每周上课时间',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              height: 5,
            ),
            AnimatedContainer(
              curve: Curves.easeOutCirc,
              duration: Duration(milliseconds: 500),
              child: MyAnimatedSize(
                curve: Curves.easeOutCirc,
                duration: Duration(milliseconds: 500),
                child: StreamBuilder<List<LessonTime>>(
                  stream: _events.stream,
                  builder: (context, snapshot) {
                    return Column(
                      children: snapshot.data
                          .map((f) => ItemLessonTime(
                                index: snapshot.data.indexOf(f),
                                lessonTime: f,
                                deleteThis: _deleteLessonPerWeek,
                                updateThis: _updateLessonPerWeek,
                              ))
                          .toList(),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Center(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: Theme.of(context).primaryColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  _incrementLessonPerWeek(context);
                },
              ),
            ),
            Divider(),
            Text(
              '课程简介',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(height: 8),
            TextField(
              onChanged: (text) {
                lessonCreating.lessonIntro = text;
                _updateLessonCreatingModel(context);
              },
              controller: lessonIntroCon,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '简单介绍课程......',
              ),
              maxLines: 3,
            ),
            Divider(),
            Text(
              '教学目标',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(height: 8),
            TextField(
              onChanged: (text) {
                lessonCreating.lessonTarget = text;
                _updateLessonCreatingModel(context);
              },
              controller: lessonTargetCon,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '课程的教学目标......',
              ),
              maxLines: 6,
            ),
            Divider(),
            Text(
              '教学计划',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(height: 8),
            TextField(
              onChanged: (text) {
                lessonCreating.lessonPlan = text;
                _updateLessonCreatingModel(context);
              },
              controller: lessonPlanCon,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '第一周...\n第二周...',
              ),
              maxLines: 6,
            ),
          ],
        ),
      ),
    );
  }
}
