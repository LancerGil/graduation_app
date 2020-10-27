import 'package:cloud_firestore/cloud_firestore.dart';

class LessonStu {
  final String stuName, stuImagePath, stuID, stuNum, groupID, docID;
  final int stuAvgScore, lessonID;
  final bool isLeader;

  LessonStu(this.stuImagePath, this.stuName, this.stuNum, this.stuAvgScore,
      this.isLeader, this.stuID, this.lessonID,
      {this.groupID = 'undecided', this.docID = 'deault docID'});

  static LessonStu fromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data;
    return LessonStu(
      //TODO:改回  data['stuImagePath']
      'assets/images/nezuko.png',
      data['stuName'],
      data['stuNum'],
      data['stuAvgScore'],
      data['isLeader'],
      data['stuID'],
      data['lessonID'],
      groupID: data['groupID'],
      docID: snapshot.documentID,
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
      'groupID': groupID,
      'docID': docID,
    };
  }
}
