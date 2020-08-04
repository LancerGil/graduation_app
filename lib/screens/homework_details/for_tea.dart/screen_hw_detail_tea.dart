import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/card_using_container.dart';
import 'package:graduationapp/custom_widgets/hw_state_text.dart';
import 'package:graduationapp/models/hw_home.dart';
import 'package:graduationapp/models/hw_question.dart';

import '../item_hwquestion.dart';

class HwDetailForTeaPage extends StatefulWidget {
  final Homework homework;

  const HwDetailForTeaPage({Key key, this.homework}) : super(key: key);
  @override
  _HwDetailForTeaPageState createState() => _HwDetailForTeaPageState();
}

class _HwDetailForTeaPageState extends State<HwDetailForTeaPage>
    with SingleTickerProviderStateMixin {
  Homework thisHw;
  TextEditingController descriCon, titleCon;
  bool _folded = true;
  Duration duration = const Duration(milliseconds: 500);
  List<String> ddlTitle = ['一评截至日期', '二评截至日期', '回评截至日期'];

  final Curve curve = Curves.easeOutCirc;
  TickerProvider tp;

  @override
  void initState() {
    super.initState();
    tp = this;
    titleCon = TextEditingController(text: widget.homework.hwTitle);
    descriCon = TextEditingController(text: widget.homework.hwDescri);
  }

  @override
  void dispose() {
    super.dispose();
    titleCon.dispose();
    descriCon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    thisHw = widget.homework;

    var appBar = AppBar(
      centerTitle: true,
      title: Text('作业详情'),
      actions: <Widget>[
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.edit),
          ),
        ),
      ],
    );

    var body = SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: <Widget>[
                  Text(
                    '当前阶段：',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  HwStateText(
                    hwState: widget.homework.hwState,
                  ),
                  Spacer(),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '截至日期：',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      TextSpan(
                        text:
                            widget.homework.ddl.first.toString().split(' ')[0],
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.red),
                      ),
                    ]),
                  ),
                ],
              ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '截止日期',
                  ),
                  ItemDDL(
                    title: "提交截至日期",
                    ddl: thisHw.ddl[0],
                  ),
                  Visibility(
                    visible: thisHw.enablePeer,
                    child: Column(
                      children: <Widget>[
                        ItemDDL(
                            title: ddlTitle[0],
                            ddl: thisHw.enablePeer
                                ? thisHw.ddl[1]
                                : DateTime.now()),
                        ItemDDL(
                            title: ddlTitle[1],
                            ddl: thisHw.enablePeer
                                ? thisHw.ddl[2]
                                : DateTime.now()),
                        ItemDDL(
                            title: ddlTitle[2],
                            ddl: thisHw.enablePeer
                                ? thisHw.ddl[3]
                                : DateTime.now()),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('学生提问'),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(),
            ),
          ],
        ),
      ),
    );

    return Scaffold(appBar: appBar, body: body);
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
