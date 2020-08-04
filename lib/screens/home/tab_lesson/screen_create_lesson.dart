import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graduationapp/models/app_model.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/models/lesson_time.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/utils/firebase_store.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateLessonPage extends StatefulWidget {
  final User user;

  const CreateLessonPage({Key key, this.user}) : super(key: key);

  @override
  _CreateLessonPageState createState() => _CreateLessonPageState();
}

class _CreateLessonPageState extends State<CreateLessonPage>
    with SingleTickerProviderStateMixin {
  int startAtWeek, finishAtWeek;
  TextEditingController lessonNameCon,
      lessonIntroCon,
      lessonTargetCon,
      lessonPlanCon;
  List<LessonTime> _myLessonsNumPerweek;
  StreamController<List<LessonTime>> _events;
  Lesson lessonCreating;
  FireBaseStore fireBaseStore;
  bool isHandling = false;

  @override
  void initState() {
    super.initState();
    startAtWeek = 1;
    finishAtWeek = 1;
    _myLessonsNumPerweek = [LessonTime()];
    lessonNameCon = TextEditingController();
    lessonIntroCon = TextEditingController();
    lessonPlanCon = TextEditingController();
    lessonTargetCon = TextEditingController();
    _events = new StreamController<List<LessonTime>>();
    _events.add(_myLessonsNumPerweek);
    fireBaseStore = FireBaseStore();
  }

  @override
  void dispose() {
    super.dispose();
    lessonNameCon.dispose();
    lessonIntroCon.dispose();
    lessonTargetCon.dispose();
    lessonPlanCon.dispose();
    _events.close();
  }

  _incrementLessonPerWeek(context) {
    _myLessonsNumPerweek.add(LessonTime());
    lessonCreating.lessonsTime = _myLessonsNumPerweek;
    _events.add(_myLessonsNumPerweek);
    _updateLessonCreatingModel(context);
  }

  _deleteLessonPerWeek(context, index) {
    _myLessonsNumPerweek.removeAt(index);
    lessonCreating.lessonsTime = _myLessonsNumPerweek;
    _events.add(_myLessonsNumPerweek);
    _updateLessonCreatingModel(context);
  }

  _updateLessonPerWeek(context, index, updatedOne) {
    _myLessonsNumPerweek[index] = updatedOne;
    lessonCreating.lessonsTime = _myLessonsNumPerweek;
    _events.add(_myLessonsNumPerweek);
    _updateLessonCreatingModel(context);
  }

  _updateLessonCreatingModel(context) {
    ScopedModel.of<AppModel>(context).setLessonCreating(lessonCreating);
    print("creating Lesson: ------ ${lessonCreating.toJson()}");
  }

  @override
  Widget build(BuildContext context) {
    lessonCreating = AppModel.of(context, rebuildOnChange: true).lessonCreating;
    User user = widget.user;

    if (lessonCreating != null) {
      setState(() {
        lessonNameCon.text = lessonCreating.lessonName;
        lessonIntroCon.text = lessonCreating.lessonIntro;
        lessonTargetCon.text = lessonCreating.lessonTarget;
        lessonPlanCon.text = lessonCreating.lessonPlan;
        startAtWeek = lessonCreating.startWeek;
        finishAtWeek = lessonCreating.finishWeek;
        _myLessonsNumPerweek = lessonCreating.lessonsTime;
        _events.add(_myLessonsNumPerweek);
      });
    } else {
      lessonCreating = Lesson(
          "", "22", user.userId, 0, "", "", "", 1, 1, [LessonTime()],
          lessonID:
              new Random(DateTime.now().second).nextInt(Lesson.MAX_LESSON_ID));
    }

    var appbar = AppBar(
      title: Text('创建课程'),
      leading: GestureDetector(
        child: Icon(Icons.arrow_back),
        onTap: () {
          showDialog(
            context: context,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Text('是否保留填写信息？'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    ScopedModel.of<AppModel>(context).setLessonCreating(null);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('否'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('是'),
                )
              ],
            ),
          );
        },
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            handleCreateLesson();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.check,
              color: Colors.greenAccent,
            ),
          ),
        )
      ],
    );
    var body = isHandling
        ? loadingScreen()
        : SingleChildScrollView(
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
                          _showWeekPicker(
                              context, startAtWeek, 25, startAtWeek);
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
                    child: AnimatedSize(
                      curve: Curves.easeOutCirc,
                      duration: Duration(milliseconds: 500),
                      vsync: this,
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

    return Scaffold(appBar: appbar, body: body);
  }

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
        setState(() {});
      }
    });
  }

  void handleCreateLesson() async {
    setState(() {
      isHandling = true;
    });
    lessonCreating = AppModel.of(context, rebuildOnChange: true).lessonCreating;
    ensureLessonIDUnique().then((value) {
      fireBaseStore.addDocument('lesson', lessonCreating.toJson());
      _showLessonCode();
    });
  }

  _showLessonCode() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('使用课程码邀请学生加入课程：'),
        content: Text(
          lessonCreating.lessonID.toString(),
          style: Theme.of(context).textTheme.headline4,
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('确定'),
          ),
        ],
      ),
    );
  }

  Future<Lesson> ensureLessonIDUnique() async {
    if (await checkIfExsit()) {
      lessonCreating.lessonID =
          new Random(new DateTime.now().second).nextInt(Lesson.MAX_LESSON_ID);
      ensureLessonIDUnique();
    } else
      return lessonCreating;
  }

  Future<bool> checkIfExsit() async {
    return await fireBaseStore
        .queryDocuments(
            'lesson', MapEntry(Lesson.LESSON_FEILD[1], lessonCreating.lessonID))
        .then((value) => value.documents != null);
  }

  loadingScreen() {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text('正在处理...'),
          ],
        ),
      ),
    );
  }
}

class ItemLessonTime extends StatefulWidget {
  final int index;
  LessonTime lessonTime;
  final Function deleteThis, updateThis;

  ItemLessonTime(
      {Key key, this.lessonTime, this.deleteThis, this.index, this.updateThis})
      : super(key: key);

  @override
  _ItemLessonTimeState createState() => _ItemLessonTimeState();
}

class _ItemLessonTimeState extends State<ItemLessonTime> {
  int weekDay = 1;
  String startAt, finishAt;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    startAt = widget.lessonTime.startAt.format(context);
    finishAt = widget.lessonTime.finishAt.format(context);
    return Container(
      height: 50,
      child: Row(
        children: <Widget>[
          SizedBox(width: 30),
          Text('${widget.index + 1}'),
          Spacer(),
          Text('星期'),
          GestureDetector(
            onTap: () {
              widget.lessonTime.setWeekDay(value: weekDay++ % 7);
              widget.updateThis(context, widget.index, widget.lessonTime);
            },
            child: Text(
              '${widget.lessonTime.weekday}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () async {
              TimeOfDay result = await _pickATimeOfDay();
              if (result == null) {
                return;
              }
              widget.lessonTime.setStartAt(result);
              widget.updateThis(context, widget.index, widget.lessonTime);
            },
            child: Text(
              '$startAt',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Text(' — '),
          GestureDetector(
            onTap: () async {
              TimeOfDay result = await _pickATimeOfDay();
              if (result == null) {
                return;
              }
              widget.lessonTime.setFinishAt(result);
              widget.updateThis(context, widget.index, widget.lessonTime);
            },
            child: Text(
              '$finishAt',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              widget.deleteThis(context, widget.index);
            },
            child: Icon(
              Icons.delete,
              color: Colors.redAccent,
            ),
          )
        ],
      ),
    );
  }

  Future<TimeOfDay> _pickATimeOfDay() async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }
}
