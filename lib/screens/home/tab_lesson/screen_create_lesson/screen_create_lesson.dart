import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graduationapp/custom_widgets/animated_size.dart';
import 'package:graduationapp/models/app_model.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/models/lesson_time.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/home/tab_lesson/screen_create_lesson/body_create_lesson.dart';
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
    setState(() {});
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
        : BodyCreateHomework(
            lessonNameCon: lessonNameCon,
            lessonCreating: lessonCreating,
            startAtWeek: startAtWeek,
            finishAtWeek: finishAtWeek,
            events: _events,
            lessonIntroCon: lessonIntroCon,
            lessonTargetCon: lessonTargetCon,
            lessonPlanCon: lessonPlanCon,
            deleteLessonPerWeek: _deleteLessonPerWeek,
            updateLessonCreatingModel: _updateLessonCreatingModel,
            incrementLessonPerWeek: _incrementLessonPerWeek,
            updateLessonPerWeek: _updateLessonPerWeek,
          );

    return Scaffold(appBar: appbar, body: body);
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
