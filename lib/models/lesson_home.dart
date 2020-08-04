import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import 'lesson_time.dart';

class Lesson extends Model {
  static const List<String> LESSON_FEILD = [
    'lessonID',
    'lessonName',
    'lessonImagePath',
    'lessonTea',
    'hwState',
    'lessonPlan',
    'lessonIntro',
    'lessonTarget',
    'startWeek',
    'finishWeek',
    'lessonsTime',
  ];
  static const int MAX_LESSON_ID = 99999;

  String lessonName,
      lessonImagePath = "22",
      lessonTea,
      lessonPlan,
      lessonIntro,
      lessonTarget;
  int hwState = 0, lessonID, startWeek, finishWeek;
  List<LessonTime> lessonsTime;

  Lesson(
      this.lessonName,
      this.lessonImagePath,
      this.lessonTea,
      this.hwState,
      this.lessonPlan,
      this.lessonIntro,
      this.lessonTarget,
      this.startWeek,
      this.finishWeek,
      this.lessonsTime,
      {this.lessonID});

  static final classID = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  static List<Lesson> fetchAll(List classIDs) {
    return classIDs
        .map(
          (id) => Lesson(
            '课程名称-Arashiyama Bamboo Grove $id',
            'assets/images/nezuko.png',
            'Soi老师$id',
            id % 7,
            '第一周\n第二周\n第三周\n第四周',
            '课程介绍详细信息详细信息详细信息详细信息详细信息详细信息详细信息详细信息详细信息详细信息',
            '教学目标教学目标教学目标教学目标教学目标教学目标教学目标',
            1,
            16,
            [
              LessonTime(),
              LessonTime(),
            ],
            lessonID: new Random(id).nextInt(MAX_LESSON_ID),
          ),
        )
        .toList();
  }

  static fromSnapshot(DocumentSnapshot snapshot, {teacher}) {
    var data = snapshot.data;
    print(data);
    List lessonsTimeStr = data[LESSON_FEILD[10]];
    List<LessonTime> lessonsTime = lessonsTimeStr
        .map<LessonTime>((e) => LessonTime.fromString(e))
        .toList();

    return Lesson(
      data[LESSON_FEILD[1]],
      data[LESSON_FEILD[2]],
      teacher,
      data[LESSON_FEILD[4]],
      data[LESSON_FEILD[5]],
      data[LESSON_FEILD[6]],
      data[LESSON_FEILD[7]],
      data[LESSON_FEILD[8]],
      data[LESSON_FEILD[9]],
      lessonsTime,
      lessonID: data[LESSON_FEILD[0]],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      LESSON_FEILD[0]: lessonID,
      LESSON_FEILD[1]: lessonName,
      LESSON_FEILD[2]: lessonImagePath,
      LESSON_FEILD[3]: lessonTea,
      LESSON_FEILD[4]: hwState,
      LESSON_FEILD[5]: lessonPlan,
      LESSON_FEILD[6]: lessonIntro,
      LESSON_FEILD[7]: lessonTarget,
      LESSON_FEILD[8]: startWeek,
      LESSON_FEILD[9]: finishWeek,
      LESSON_FEILD[10]: lessonsTime.map((e) => e.toString()).toList(),
    };
  }
}
