import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/models/comment_angle.dart';
import 'package:graduationapp/models/hw_home.dart';
import 'package:graduationapp/models/submission.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/homework_details/for_tea.dart/tea_comment_sheet_body.dart';
import 'package:graduationapp/screens/homework_details/peer_comment/comment_one_angle.dart';
import 'package:graduationapp/utils/firebase_store.dart';
import 'package:graduationapp/utils/flutter_toast.dart';

class TeaCommentSheet extends StatefulWidget {
  final Homework homework;
  final Submission submission;
  final User user;

  const TeaCommentSheet({Key key, this.submission, this.user, this.homework})
      : super(key: key);
  @override
  _TeaCommentSheetState createState() => _TeaCommentSheetState();
}

class _TeaCommentSheetState extends State<TeaCommentSheet> {
  double _initialPersentage = 0.2;
  FireBaseStore fireBaseStore;

  String currentCommentContent;

  List<CommentOfOneAngle> commentFromEachAngle =
      List(CommentAngle.ANGLE.length);
  CommentAngle existingCommentAngle;

  @override
  void initState() {
    fireBaseStore = FireBaseStore();
    checkIfCommentExisting();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkIfCommentExisting() async {
    QuerySnapshot snapshot =
        await fireBaseStore.doubleQueryDocuments('peer_comment', {
      'submitID': widget.submission.submitID,
      'commentUserID': widget.user.userId,
    });
    if (snapshot.documents != null && snapshot.documents.isNotEmpty) {
      if (mounted) {
        setState(() {
          existingCommentAngle =
              CommentAngle.fromSnapshot(snapshot.documents.first);

          if (existingCommentAngle != null) {
            for (int i = 0; i < CommentAngle.ANGLE.length; i++) {
              commentFromEachAngle[i] = CommentOfOneAngle(
                  i,
                  existingCommentAngle.score[i],
                  existingCommentAngle.commentContent[i]);
            }
            print(commentFromEachAngle);
          }
        });
      }
    }
  }

  updateCommentList(int index, int score, String content) {
    print('score:$score----content:$content');
    commentFromEachAngle[index] = CommentOfOneAngle(index, score, content);
    print(commentFromEachAngle);
  }

  bool checkIfAllFilled() {
    for (var item in commentFromEachAngle) {
      if (item != null && item.validate())
        continue;
      else
        return false;
    }
    return true;
  }

  void submitCommentToServer() {
    String docID = existingCommentAngle?.docID;
    List<String> contents = List(CommentAngle.ANGLE.length);
    List<int> scores = List(CommentAngle.ANGLE.length);

    for (int i = 0; i < CommentAngle.ANGLE.length; i++) {
      contents[i] = commentFromEachAngle[i].content;
      scores[i] = commentFromEachAngle[i].score;
    }

    var commentSubmit = CommentAngle(
        widget.submission.submitID,
        widget.submission.userID,
        widget.submission.stuName,
        widget.user.userId,
        widget.user.fullname,
        widget.homework.lessonName,
        widget.homework.hwTitle,
        false,
        widget.user.identity == 'teacher',
        contents,
        scores,
        DateTime.now(),
        docID: docID);
    print(commentSubmit.toJson());
    if (docID != null) {
      fireBaseStore.updateDocument(
          'peer_comment', docID, commentSubmit.toJson());
    } else
      fireBaseStore.addDocument('peer_comment', commentSubmit.toJson());
    MyFlutterToast.showToast('提交成功', context);
  }

  void completedComment() {
    if (checkIfAllFilled()) {
      submitCommentToServer();
    } else
      MyFlutterToast.showToast('请确保所有角度给出非零评分和评语', context);
  }

  @override
  Widget build(BuildContext context) {
    return TeaCommentSheetBody(
      initialPersentage: _initialPersentage,
      submit: completedComment,
      commentFromEachAngle: commentFromEachAngle,
      updateCommentList: updateCommentList,
      commentAngle: existingCommentAngle,
    );
  }
}
