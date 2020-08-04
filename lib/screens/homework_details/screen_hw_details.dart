import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/animated_size.dart';
import 'package:graduationapp/custom_widgets/card_using_container.dart';
import 'package:graduationapp/custom_widgets/hw_state_text.dart';
import 'package:graduationapp/models/hw_home.dart';
import 'package:graduationapp/models/hw_question.dart';
import 'package:graduationapp/models/hw_summit.dart';
import 'package:graduationapp/screens/homework_details/item_hwquestion.dart';

import 'item_peer_summit.dart';
import 'summitsheet.dart';

const double minSheetHeight = 120;

class HomeworkPage extends StatefulWidget {
  final Homework homework;
  final bool hasSummited = false;

  HomeworkPage({Key key, this.homework}) : super(key: key);

  @override
  _HomeworkPageState createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage>
    with SingleTickerProviderStateMixin {
  bool _folded = true;
  Duration duration = const Duration(milliseconds: 500);

  final Curve curve = Curves.easeOutCirc;
  TickerProvider tp;
  List<HWSummit> peerSummitList = [];

  bool _asking = false;

  @override
  void initState() {
    super.initState();
    tp = this;
    _buildPeerSummit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _buildPeerSummit() async {
    var list = await HWSummit.fetch(3);
    print('-----------HWSummit.fetch------------$list');
    setState(() {
      peerSummitList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    '当前阶段:  ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.black),
                  ),
                  HwStateText(hwState: widget.homework.hwState),
                  Spacer(),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '截至日期：',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      TextSpan(
                        text: widget.homework.ddl[widget.homework.hwState - 1]
                            .toString()
                            .split(' ')[0],
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
              ShadowContainer(
                padding: const EdgeInsets.all(15.0),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '题目',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(widget.homework.hwTitle),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              AnimatedContainer(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
                duration: duration,
                curve: curve,
              ),
              SizedBox(
                height: 15.0,
              ),
              Divider(
                indent: 16,
                endIndent: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('作业答疑：'),
                        Text(
                          '对作业要求有疑问？大胆向老师提出疑问',
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                    RaisedButton(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onPressed: () {
                        setState(() {
                          _asking = !_asking;
                          if (!_asking) {
                            //TODO: 提交疑问。
                          }
                        });
                      },
                      child: Text(
                        _asking ? "取消" : '提问',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
              MyAnimeSize(
                duration: duration,
                curve: curve,
                child: Visibility(
                    visible: _asking,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
                      child: TextField(
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: '写下你的疑惑'),
                      ),
                    )),
              ),
              AnimatedContainer(
                duration: duration,
                curve: curve,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _buildHwQuestions(),
                  ),
                ),
              ),
              Divider(
                indent: 16,
                endIndent: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text('同伴互评：'),
              ),
              SizedBox(
                height: 15.0,
              ),
              Visibility(
                visible: widget.homework.hwState != 1,
                child: Column(
                  children: _buildPeerSummitsWidgets(peerSummitList),
                ),
              ),
              Visibility(
                  visible: widget.homework.hwState == 1,
                  child: Text(
                    '提交阶段尚无需同伴评估。',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.16,
              )
            ]
            // ..add(Spacer()),
            ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: SummitSheet(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  List<Widget> _buildPeerSummitsWidgets(List<HWSummit> summits) {
    return summits.map((f) => ItemPeerSummit(summit: f)).toList();
  }

  List<Widget> _buildHwQuestions() {
    List questions = HWQuestion.fetch(4);
    // List questions = [];
    return questions.length == 0
        ? [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '尚无学生提问',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
          ]
        : questions
            .map(
              (f) => ItemHWQuestion(
                question: f,
              ),
            )
            .toList();
  }
}
