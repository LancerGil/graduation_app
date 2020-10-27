import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/models/comment_angle.dart';
import 'package:graduationapp/models/hw_home.dart';
import 'package:graduationapp/models/submission.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/utils/firebase_store.dart';
import 'package:graduationapp/utils/flutter_toast.dart';

import 'body_peercomment.dart';
import 'comment_one_angle.dart';

class PeerCommentPage extends StatefulWidget {
  final Homework homework;
  final Submission submission;
  final bool isFirstPeriodOfComment;
  final User user;

  const PeerCommentPage(
      {Key key,
      this.submission,
      this.isFirstPeriodOfComment,
      this.user,
      this.homework})
      : super(key: key);
  @override
  _PeerCommentPageState createState() => _PeerCommentPageState();
}

class _PeerCommentPageState extends State<PeerCommentPage> {
  List<CommentOfOneAngle> commentFromEachAngle =
      List(CommentAngle.ANGLE.length);
  FireBaseStore fireBaseStore = FireBaseStore();
  CommentAngle existingCommentAngle;

  @override
  void initState() {
    checkIfCommentExisting();
    super.initState();
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
          if (!widget.isFirstPeriodOfComment && snapshot.documents.length > 1) {
            existingCommentAngle = CommentAngle.fromSnapshot(snapshot.documents
                    .firstWhere(
                        (element) => element.data['isFirstPeriod'] == false) ??
                null);
          }
          if (widget.isFirstPeriodOfComment && snapshot.documents.length == 1) {
            existingCommentAngle = CommentAngle.fromSnapshot(snapshot.documents
                    .firstWhere(
                        (element) => element.data['isFirstPeriod'] == true) ??
                null);
          }
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
        widget.isFirstPeriodOfComment,
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
    var appBar = AppBar(
      centerTitle: true,
      title: Text('同伴作业点评'),
      actions: [
        IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.green,
            ),
            onPressed: () {
              completedComment();
            })
      ],
    );
    var body = BodyPeerCommentFromAngle(
      isFirstPeriodOfComment: widget.isFirstPeriodOfComment,
      updateCommentList: updateCommentList,
      commentFromEachAngle: commentFromEachAngle,
      submission: widget.submission,
    );

    return Scaffold(
      appBar: appBar,
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: body),
    );
  }
}
