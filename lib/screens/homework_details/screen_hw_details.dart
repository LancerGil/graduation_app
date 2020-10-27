import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/hw_state_text.dart';
import 'package:graduationapp/models/hw_home.dart';
import 'package:graduationapp/models/submission.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/utils/firebase_store.dart';

import 'item_peer_submit.dart';
import 'submitsheet/submitsheet.dart';

const double minSheetHeight = 120;

class HomeworkPage extends StatefulWidget {
  final User user;
  final Homework homework;

  HomeworkPage({Key key, this.homework, this.user}) : super(key: key);

  @override
  _HomeworkPageState createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage>
    with SingleTickerProviderStateMixin {
  bool hasSummited = false;
  bool _folded = true;
  Duration duration = const Duration(milliseconds: 500);
  final Curve curve = Curves.easeOutCirc;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  TickerProvider tp;
  List<Submission> peerSummitList;
  FireBaseStore _fireBaseStore;
  final List<String> hintOfPeerCommentModule = [
    '该作业无需同伴互评。',
    '提交阶段尚无需同伴互评。',
    '请对下列同学的作业做出评估',
  ];

  @override
  void initState() {
    super.initState();
    tp = this;
    _fireBaseStore = FireBaseStore();
    _getPeerSubmission();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getPeerSubmission() async {
    print('-----------getting Submission from DB------------');
    QuerySnapshot querySnapshot = await _fireBaseStore.queryDocuments(
        'submission', MapEntry('hwID', widget.homework.hwID));
    if (querySnapshot.documents != null && querySnapshot.documents.isNotEmpty) {
      peerSummitList = querySnapshot.documents
          .map<Submission>((e) => Submission.fromSnapshot(e))
          .toList();
    } else {
      peerSummitList = [];
    }
    if (this.mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MapEntry currentStatus = widget.homework.getCurrentStatus();
    Map ableOrNot = widget.homework.getWhatIsAble();

    var appBar = AppBar(
      title: Text(widget.homework.lessonName.toString() + '的作业'),
      centerTitle: true,
    );
    var body = SingleChildScrollView(
      child: AnimatedContainer(
        duration: duration,
        curve: curve,
        color: Colors.white,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(children: <Widget>[
                  Text(
                    '当前状态:  ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.black),
                  ),
                  HwStateText(hwState: currentStatus.key),
                  Spacer(),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '截至日期：',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      TextSpan(
                        text: currentStatus.value == null
                            ? '已截止'
                            : currentStatus.value.toString().split(' ')[0],
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.red),
                      ),
                    ]),
                  ),
                ]),
              ),
              SizedBox(
                height: 3.0,
              ),
              AnimatedContainer(
                duration: duration,
                curve: curve,
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withAlpha(150), blurRadius: 13.0)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '题目',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(widget.homework.hwTitle),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '要求详情',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _folded = !_folded;
                                });
                              },
                              child: Text(
                                _folded ? '展开' : '收起',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        AnimatedSize(
                          curve: curve,
                          duration: duration,
                          vsync: tp,
                          child: Text(
                            widget.homework.hwDescri,
                            overflow: TextOverflow.fade,
                            maxLines: _folded ? 2 : null,
                          ),
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                indent: 16,
                endIndent: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text('同伴互评任务'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  currentStatus.key == 0
                      ? hintOfPeerCommentModule[0]
                      : ableOrNot['giveComment']
                          ? hintOfPeerCommentModule[2]
                          : hintOfPeerCommentModule[1],
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Visibility(
                visible: ableOrNot['giveComment'],
                child: Column(
                  children: peerSummitList == null
                      ? [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          )
                        ]
                      : _buildPeerSummitsWidgets(peerSummitList),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              )
            ]
            // ..add(Spacer()),
            ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      body: body,
      floatingActionButton: SubmitSheet(
        scaffoldKey: _scaffoldKey,
        user: widget.user,
        homework: widget.homework,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  List<Widget> _buildPeerSummitsWidgets(List<Submission> submissions) {
    return submissions.map((f) {
      if (f.userID != widget.user.userId) {
        return ItemPeerSubmit(
          submission: f,
          user: widget.user,
          homework: widget.homework,
        );
      } else {
        return Container();
      }
    }).toList();
  }
}
