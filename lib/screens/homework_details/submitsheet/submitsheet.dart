import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/models/comment_angle.dart';
import 'package:graduationapp/models/hw_home.dart';
import 'package:graduationapp/models/submission.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/homework_details/submitsheet/body_submitsheet.dart';
import 'package:graduationapp/utils/firebase_store.dart';
import 'package:graduationapp/utils/flutter_toast.dart';

class SubmitSheet extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final User user;
  final Homework homework;

  const SubmitSheet({Key key, this.scaffoldKey, this.homework, this.user})
      : super(key: key);

  @override
  _SubmitSheetState createState() => _SubmitSheetState();
}

class _SubmitSheetState extends State<SubmitSheet>
    with SingleTickerProviderStateMixin {
  static const String TAG = '-----submitsheet----';
  double initialPersentage = 0.2;

  bool firstSubmit = true, teaCommentChecked = false;
  Submission _submission;
  FireBaseStore _fireBaseStore;
  TextEditingController articleToSubmit;
  String currentHwContent;
  List<CommentAngle> peerComments;

  @override
  void initState() {
    super.initState();
    _fireBaseStore = FireBaseStore();
    articleToSubmit = TextEditingController();
    _initialDataFromDB();
  }

  @override
  void dispose() {
    super.dispose();
    articleToSubmit.dispose();
  }

  _initialDataFromDB() {
    _initialSubmission();
  }

  _initialSubmission() async {
    QuerySnapshot submissonFromDB = await _fireBaseStore.doubleQueryDocuments(
        'submission',
        {'userID': widget.user.userId, 'hwID': widget.homework.hwID});
    if (submissonFromDB.documents != null &&
        submissonFromDB.documents.isNotEmpty) {
      _submission = Submission.fromSnapshot(submissonFromDB.documents.first);
      firstSubmit = false;
      articleToSubmit.text = widget.homework.hwState < 3
          ? _submission.hwContent_1
          : _submission.hwContent_2 == ''
              ? _submission.hwContent_1
              : _submission.hwContent_2;
      currentHwContent = widget.homework.hwState < 3
          ? _submission.hwContent_1
          : _submission.hwContent_2 == ''
              ? _submission.hwContent_1
              : _submission.hwContent_2;
      if (this.mounted) {
        setState(() {});
      }
      _initialPeerComments();
    } else {
      peerComments = [];
    }
  }

  _initialPeerComments() async {
    QuerySnapshot querySnapshot = await _fireBaseStore.queryDocuments(
        'peer_comment', MapEntry('submitID', _submission.submitID));
    peerComments = [];
    if (querySnapshot.documents != null && querySnapshot.documents.isNotEmpty) {
      print('got some peercomments');
      peerComments = querySnapshot.documents
          .map<CommentAngle>((e) => CommentAngle.fromSnapshot(e))
          .toList();
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  submitHW() {
    if (articleToSubmit.text.trim().isEmpty) {
      MyFlutterToast.showToast("不能提交空白作业。", context);
    } else if (firstSubmit) {
      print(
          '$TAG submitHW is not empty & first submit: HwState = ${widget.homework.hwState}');
      print('${articleToSubmit.text}');
      Submission submisson = Submission(
          widget.user.userId,
          widget.homework.hwID,
          widget.user.fullname,
          widget.user.stuID,
          widget.homework.hwState < 3
              ? articleToSubmit.text
              : _submission == null
                  ? ''
                  : _submission.hwContent_1,
          widget.homework.hwState < 7 && widget.homework.hwState > 2
              ? articleToSubmit.text
              : '',
          DateTime.now());
      _fireBaseStore.addDocument('submission', submisson.toJson());
      updateDoneStuAtCloud();
      MyFlutterToast.showToast('提交成功', context);
    } else {
      print('$TAG submitHW is not empty & not first submit:');
      print('${articleToSubmit.text}');
      if (articleToSubmit.text == currentHwContent) {
        MyFlutterToast.showToast('尚无发现修改', context);
        return;
      }
      currentHwContent = articleToSubmit.text;
      Submission submisson = Submission(
          widget.user.userId,
          widget.homework.hwID,
          widget.user.fullname,
          widget.user.stuID,
          widget.homework.hwState == 1
              ? articleToSubmit.text
              : _submission.hwContent_1,
          widget.homework.hwState == 3 ? articleToSubmit.text : '',
          DateTime.now());
      _fireBaseStore.updateDocument(
          'submission', _submission.submitID, submisson.toJson());
      MyFlutterToast.showToast('修改成功', context);
    }
  }

  updateDoneStuAtCloud() {
    var key = "hwDoneStu";
    print('$TAG updating done students on ${widget.homework.docID}');
    _fireBaseStore.updateDocument('homework', widget.homework.docID,
        {key: widget.homework.hwDoneStu + 1});
  }

  @override
  Widget build(BuildContext context) {
    MapEntry<int, DateTime> currentStatus = widget.homework.getCurrentStatus();
    Map<String, bool> ableORnot = widget.homework.getWhatIsAble();
    if (firstSubmit) {
      ableORnot['submit'] = true;
    }

    return MyDraggableScrollableSheet(
      initialPersentage: initialPersentage,
      currentStatus: currentStatus,
      peerComments: peerComments,
      isFirstSubmit: firstSubmit,
      submission: _submission,
      ableORnot: ableORnot,
      articleToSubmit: articleToSubmit,
      submitHW: submitHW,
    );
  }
}

class DragBar extends StatelessWidget {
  const DragBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 21,
      child: IgnorePointer(
        ignoring: true,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              width: 50,
              height: 8,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ),
      ),
    );
  }
}
