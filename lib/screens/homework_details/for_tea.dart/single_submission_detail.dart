import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/models/comment_angle.dart';
import 'package:graduationapp/models/hw_home.dart';
import 'package:graduationapp/models/submission.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/homework_details/for_tea.dart/submission_detail_body.dart';
import 'package:graduationapp/screens/homework_details/for_tea.dart/tea_comment_sheet.dart';
import 'package:graduationapp/utils/firebase_store.dart';

class SingleSubmissionDetail extends StatefulWidget {
  final Submission submission;
  final Homework homework;
  final User user;

  const SingleSubmissionDetail(
      {Key key, this.submission, this.homework, this.user})
      : super(key: key);

  @override
  _SingleSubmissionDetailState createState() => _SingleSubmissionDetailState();
}

class _SingleSubmissionDetailState extends State<SingleSubmissionDetail> {
  Submission _submission;
  List<CommentAngle> _peerComments;
  FireBaseStore _fireBaseStore;

  @override
  void initState() {
    super.initState();
    _submission = widget.submission;
    _fireBaseStore = FireBaseStore();
    _initialPeerComments();
  }

  _initialPeerComments() async {
    QuerySnapshot querySnapshot = await _fireBaseStore.queryDocuments(
        'peer_comment', MapEntry('submitID', _submission.submitID));
    if (querySnapshot.documents != null && querySnapshot.documents.isNotEmpty) {
      _peerComments = querySnapshot.documents
          .map<CommentAngle>((e) => CommentAngle.fromSnapshot(e))
          .toList();
    } else {
      _peerComments = [];
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      centerTitle: true,
      title: Text('提交详情'),
    );
    var body = SubmissionDetailBody(
        submission: _submission,
        homework: widget.homework,
        peerComments: _peerComments);

    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: TeaCommentSheet(
        homework: widget.homework,
        submission: widget.submission,
        user: widget.user,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
