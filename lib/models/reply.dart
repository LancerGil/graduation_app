import 'package:cloud_firestore/cloud_firestore.dart';

class Reply {
  final String docID,
      commentDocID,
      oppositeUserID,
      oppositeName,
      myUserID,
      myName,
      hwTitle,
      lessonName,
      content;
  final int score;
  final DateTime updateAt;

  Reply(
    this.docID,
    this.commentDocID,
    this.content,
    this.oppositeUserID,
    this.oppositeName,
    this.myUserID,
    this.myName,
    this.hwTitle,
    this.lessonName,
    this.score,
    this.updateAt,
  );

  static Reply fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data;
    DateTime updateAt = (data['updateAt'] as Timestamp)?.toDate();
    return Reply(
      snapshot.documentID,
      data['commentDocID'],
      data['content'],
      data['oppositeUserID'],
      data['oppositeName'],
      data['myUserID'],
      data['myName'],
      data['hwTitle'],
      data['lessonName'],
      data['score'],
      updateAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentDocID': commentDocID,
      'content': content,
      'oppositeUserID': oppositeUserID,
      'oppositeName': oppositeName,
      'myUserID': myUserID,
      'myName': myName,
      'hwTitle': hwTitle,
      'lessonName': lessonName,
      'score': score,
      'updateAt': updateAt,
    };
  }
}
