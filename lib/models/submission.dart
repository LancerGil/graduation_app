import 'package:cloud_firestore/cloud_firestore.dart';

class Submission {
  final String submitID, userID, hwContent_1, hwContent_2, stuName, stuID;
  final int hwID;
  final DateTime updateAt;

  Submission(this.userID, this.hwID, this.stuName, this.stuID, this.hwContent_1,
      this.hwContent_2, this.updateAt,
      [this.submitID = "default submitID"]);

  Map<String, dynamic> toJson() {
    return {
      "submitID": submitID,
      "userID": userID,
      "hwID": hwID,
      "stuName": stuName,
      "stuID": stuID,
      "hwContent_1": hwContent_1,
      "hwContent_2": hwContent_2,
      "updateAt": updateAt,
    };
  }

  static Submission fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data;
    print(data);
    DateTime updateAt = (data['updateAt'] as Timestamp)?.toDate();
    return Submission(
      data['userID'],
      data['hwID'],
      data['stuName'],
      data['stuID'],
      data['hwContent_1'],
      data['hwContent_2'],
      updateAt,
      snapshot.documentID,
    );
  }
}
