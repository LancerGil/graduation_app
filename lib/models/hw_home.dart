import 'package:cloud_firestore/cloud_firestore.dart';

class Homework {
  String hwTitle, hwAssetPath, hwDescri, lessonName, docID = 'default docID';
  int hwState, hwDoneStu, hwLessonID, hwID;
  bool enablePeer;
  List<DateTime> ddl;
  List summitTypeChecks;

  static const List<String> peerOptions = [
    '一评截至日期',
    '二稿截止日期',
    '二评截至日期',
  ];

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
    this.ddl, {
    this.hwID,
    this.docID,
  });

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
      hwID: data['hwID'],
      docID: snapshot.documentID,
    );
  }

  MapEntry<int, DateTime> getCurrentStatus() {
    DateTime currentDDL = ddl[0], dateTimeNow = DateTime.now();
    int lastDDL = 0;
    int hwState = 0;
    if (enablePeer) {
      hwState++;
      lastDDL = ddl.length - 1;
      for (int i = 0; i < ddl.length; i++) {
        if (dateTimeNow.isAfter(ddl[i])) {
          if (i == lastDDL) {
            hwState++;
            currentDDL = null;
            continue;
          }
          currentDDL = ddl[i + 1];
          hwState++;
        }
      }
    } else if (currentDDL.isBefore(dateTimeNow)) {
      currentDDL = null;
    }

    return MapEntry(hwState, currentDDL);
  }

  Map<String, bool> getWhatIsAble() {
    MapEntry<int, DateTime> currentStatus = getCurrentStatus();
    Map<String, bool> preset = {
      'submit': false,
      'giveComment': false,
      'giveReply': false,
    };
    switch (currentStatus.key) {
      case 0:
        if (currentStatus.value != null) preset['submit'] = true;
        break;
      case 1:
        preset['submit'] = true;
        break;
      case 2:
        preset['giveComment'] = true;
        break;
      case 3:
        preset['submit'] = true;
        break;
      case 4:
        preset['giveComment'] = true;
        break;
      case 5:
        preset['giveReply'] = true;
        break;
      default:
    }
    return preset;
  }

  Map<String, dynamic> toJson() {
    return {
      'docID': docID,
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
