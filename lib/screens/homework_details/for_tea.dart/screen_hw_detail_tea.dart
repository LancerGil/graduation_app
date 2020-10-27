import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/models/app_model.dart';
import 'package:graduationapp/models/hw_home.dart';
import 'package:graduationapp/models/submission.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/homework_details/create_hw.dart';
import 'package:graduationapp/utils/firebase_store.dart';
import 'package:scoped_model/scoped_model.dart';

import 'hw_detail_tea_body.dart';

class HwDetailForTeaPage extends StatefulWidget {
  final Homework homework;
  final User user;

  const HwDetailForTeaPage({Key key, this.homework, this.user})
      : super(key: key);
  @override
  _HwDetailForTeaPageState createState() => _HwDetailForTeaPageState();
}

class _HwDetailForTeaPageState extends State<HwDetailForTeaPage>
    with SingleTickerProviderStateMixin {
  Homework thisHw;
  int mountOfStu = 0;

  TextEditingController descriCon, titleCon;
  Duration duration = const Duration(milliseconds: 500);
  final Curve curve = Curves.easeOutCirc;

  TickerProvider tp;

  List<Submission> submissions;
  FireBaseStore _fireBaseStore;

  @override
  void initState() {
    super.initState();
    tp = this;
    titleCon = TextEditingController(text: widget.homework.hwTitle);
    descriCon = TextEditingController(text: widget.homework.hwDescri);
    _fireBaseStore = FireBaseStore();
    _getSubmissionsFromDB();
    _getThisLesson();
  }

  @override
  void dispose() {
    super.dispose();
    titleCon.dispose();
    descriCon.dispose();
  }

  _getSubmissionsFromDB() async {
    QuerySnapshot querySnapshot = await _fireBaseStore.queryDocuments(
        'submission', MapEntry('hwID', widget.homework.hwID));
    if (querySnapshot.documents != null && querySnapshot.documents.isNotEmpty)
      submissions = querySnapshot.documents
          .map<Submission>((e) => Submission.fromSnapshot(e))
          .toList();
    else
      submissions = [];
    if (this.mounted) {
      setState(() {});
    }
  }

  _getThisLesson() async {
    QuerySnapshot querySnapshot = await _fireBaseStore.queryDocuments(
        'lesson_stu', MapEntry('lessonID', widget.homework.hwLessonID));
    if (querySnapshot.documents != null &&
        querySnapshot.documents.isNotEmpty) if (this.mounted) {
      setState(() {
        mountOfStu = querySnapshot.documents.length;
      });
    }
  }

  updateHomework() {
    thisHw = ScopedModel.of<AppModel>(context).hwCreating;
  }

  @override
  Widget build(BuildContext context) {
    thisHw = widget.homework;
    MapEntry currentStatus = thisHw.getCurrentStatus();

    var appBar = AppBar(
      centerTitle: true,
      title: Text('作业详情'),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateHWPage(
                  homework: widget.homework,
                  updateHomework: updateHomework,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.edit),
          ),
        ),
      ],
    );

    var body = HWdetailTeaBody(
        currentStatus: currentStatus,
        curve: curve,
        duration: duration,
        tp: tp,
        thisHw: thisHw,
        submissions: submissions,
        mountOfStu: mountOfStu,
        homework: widget.homework,
        user: widget.user);

    return Scaffold(appBar: appBar, body: body);
  }
}

class ItemDDL extends StatelessWidget {
  final DateTime ddl;
  final String title;

  const ItemDDL({Key key, this.ddl, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
          ),
          Text(
            ddl.toString().split(' ')[0],
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }
}
