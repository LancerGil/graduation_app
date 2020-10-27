import 'package:cloud_firestore/cloud_firestore.dart';

class StuGroup {
  final int lessonID;
  final String groupName, groupID;
  final List memberUserIDs;

  StuGroup({
    this.lessonID,
    this.groupID = 'default groupID',
    this.groupName,
    this.memberUserIDs,
  });

  static StuGroup fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data;
    return StuGroup(
      lessonID: data['lessonID'],
      groupID: snapshot.documentID,
      groupName: data['groupName'],
      memberUserIDs: data['memberUserIDs'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonID': lessonID,
      'groupID': groupID,
      'groupName': groupName,
      'memberUserIDs': memberUserIDs,
    };
  }
}
