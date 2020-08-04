import 'package:cloud_firestore/cloud_firestore.dart';

class Homework {
  String hwTitle, hwAssetPath, hwDescri, lessonName;
  int hwState, hwDoneStu, hwLessonID, hwID;
  bool enablePeer;
  List<DateTime> ddl;
  List summitTypeChecks;

  Homework(
      this.hwAssetPath,
      this.hwTitle,
      this.hwLessonID,
      this.lessonName,
      this.hwState,
      this.hwDoneStu,
      this.hwDescri,
      this.enablePeer,
      this.summitTypeChecks,
      this.ddl,
      {this.hwID});

  static List<Homework> fetchAll(List classIDs) {
    return classIDs
        .map(
          (id) => Homework(
            'assets/images/nezuko.png',
            '第一章第二节2-1、2、3题',
            53447,
            'java',
            id % 7,
            30,
            '作业具体要求\n作业具体要求\n作业具体要求\n作业具体要求\n作业具体要求\n作业具体要求\n作业具体要求',
            false,
            [false, false, true, false],
            [DateTime.now(), null, null, null],
            hwID: id,
          ),
        )
        .toList();
  }

  static Homework fromDocSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data;
    print(data);
    List dataSummitTypeChecks = data['summitTypeChecks'];
    List<bool> summitTypeChecks =
        dataSummitTypeChecks.map<bool>((e) => e).toList();
    List dataDDL = data['ddl'];
    List<DateTime> ddl =
        dataDDL.map<DateTime>((e) => (e as Timestamp)?.toDate()).toList();
    return Homework(
        data['hwAssetPath'],
        data['hwTitle'],
        data['hwLessonID'],
        data['hwLessonName'],
        data['hwState'],
        data['hwDoneStu'],
        data['hwDescri'],
        data['enablePeer'],
        summitTypeChecks,
        ddl,
        hwID: 10007);
  }

  Map<String, dynamic> toJson() {
    return {
      "hwID": hwID,
      "hwAssetPath": hwAssetPath,
      "hwTitle": hwTitle,
      "hwLessonID": hwLessonID,
      "hwLessonName": lessonName,
      "hwState": hwState,
      "hwDoneStu": hwDoneStu,
      "hwDescri": hwDescri,
      "enablePeer": enablePeer,
      "summitTypeChecks": summitTypeChecks,
      "ddl": ddl,
    };
  }
}
