import 'package:cloud_firestore/cloud_firestore.dart';

class LessonStu {
  final String stuName, stuImagePath, stuID, stuNum;
  final int stuAvgScore, lessonID;
  final bool isLeader;

  LessonStu(
    this.stuImagePath,
    this.stuName,
    this.stuNum,
    this.stuAvgScore,
    this.isLeader,
    this.stuID,
    this.lessonID,
  );

  static List<LessonStu> fetchAll(List classIDs) {
    return classIDs
        .map(
          (id) => LessonStu(
            'assets/images/nezuko.png',
            '学生名字',
            "20161003441",
            90,
            id % 4 == 0 ? true : false,
            "xxxx",
            4567,
          ),
        )
        .toList();
  }

  static LessonStu fromDoc(DocumentSnapshot snapshot) {
    Map data = snapshot.data;
    return LessonStu(
      data['stuImagePath'],
      data['stuName'],
      data['stuNum'],
      data['stuAvgScore'],
      data['isLeader'],
      data['stuID'],
      data['lessonID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stuID': stuID,
      'lessonID': lessonID,
      'stuName': stuName,
      'stuImagePath': stuImagePath,
      'stuAvgScore': stuAvgScore,
      'stuNum': stuNum,
      'isLeader': isLeader,
    };
  }
}
