import 'lesson_time.dart';

class LessonNow {
  String lessonName,
      lessonImagePath,
      lessonTea,
      lessonPlan,
      lessonIntro,
      lessonTarget;
  int hwState, lessonID, startWeek, finishWeek;
  List<LessonTime> lessonsTime;

  LessonNow(
      this.lessonID,
      this.lessonName,
      this.lessonImagePath,
      this.lessonTea,
      this.hwState,
      this.lessonPlan,
      this.lessonIntro,
      this.lessonTarget,
      this.startWeek,
      this.finishWeek,
      this.lessonsTime);

  static final classID = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  static List<LessonNow> fetchAll(List classIDs) {
    return classIDs
        .map(
          (id) => LessonNow(
              id,
              '课程名称-Arashiyama Bamboo Grove $id',
              'assets/images/nezuko.png',
              'Soi老师$id',
              id % 7,
              '第一周\n第二周\n第三周\n第四周',
              '课程介绍详细信息详细信息详细信息详细信息详细信息详细信息详细信息详细信息详细信息详细信息',
              '教学目标教学目标教学目标教学目标教学目标教学目标教学目标',
              1,
              16, [
            LessonTime(),
            LessonTime(),
          ]),
        )
        .toList();
  }
}
