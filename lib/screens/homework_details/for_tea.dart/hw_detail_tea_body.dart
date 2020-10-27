import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/shadow_container.dart';
import 'package:graduationapp/custom_widgets/hw_state_text.dart';
import 'package:graduationapp/models/hw_home.dart';
import 'package:graduationapp/models/submission.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/homework_details/for_tea.dart/screen_hw_detail_tea.dart';

import 'item_submission.dart';

class HWdetailTeaBody extends StatelessWidget {
  const HWdetailTeaBody({
    Key key,
    @required this.currentStatus,
    @required this.curve,
    @required this.duration,
    @required this.tp,
    @required this.thisHw,
    @required this.submissions,
    @required this.mountOfStu,
    this.user,
    this.homework,
  }) : super(key: key);

  final MapEntry currentStatus;
  final Curve curve;
  final Duration duration;
  final TickerProvider tp;
  final Homework thisHw;
  final List<Submission> submissions;
  final int mountOfStu;
  final User user;
  final Homework homework;

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildSubmitedStuList() {
      if (submissions.isNotEmpty)
        return submissions
            .map((e) => ItemSubmission(
                  submission: e,
                  homework: homework,
                  user: user,
                ))
            .toList();
      else
        return [
          Text(
            '尚无学生提交作业',
            style: Theme.of(context).textTheme.bodyText1,
          )
        ];
    }

    _buildDDLItem() {
      List<ItemDDL> itemDDLs = [];
      if (thisHw.enablePeer) {
        for (int i = 1; i < thisHw.ddl.length; i++) {
          itemDDLs.add(new ItemDDL(
              title: Homework.peerOptions[i - 1], ddl: thisHw.ddl[i]));
        }
        return itemDDLs;
      } else {
        return [Container()];
      }
    }

    return SingleChildScrollView(
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
                    '当前状态：',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  HwStateText(
                    hwState: currentStatus.key,
                  ),
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
                ],
              ),
            ),
            SizedBox(
              height: 3.0,
            ),
            ShadowContainer(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '题目',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(homework.hwTitle),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '要求详情',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                      Text(
                        homework.hwDescri,
                        overflow: TextOverflow.fade,
                        maxLines: null,
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 10.0,
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
                      children: _buildDDLItem(),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('提交情况'),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '完成度：',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      TextSpan(
                        text: '${submissions?.length}/$mountOfStu',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.green),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            Column(
              children: submissions == null
                  ? [SubmitPlaceholder()]
                  : _buildSubmitedStuList(),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class SubmitPlaceholder extends StatefulWidget {
  @override
  _SubmitPlaceholderState createState() => _SubmitPlaceholderState();
}

class _SubmitPlaceholderState extends State<SubmitPlaceholder> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
