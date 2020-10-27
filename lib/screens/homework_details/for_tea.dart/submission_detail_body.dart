import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/hw_state_text.dart';
import 'package:graduationapp/models/comment_angle.dart';
import 'package:graduationapp/models/hw_home.dart';
import 'package:graduationapp/models/submission.dart';
import 'package:graduationapp/screens/homework_details/submitsheet/item_recieved_comment.dart';

class SubmissionDetailBody extends StatelessWidget {
  const SubmissionDetailBody({
    Key key,
    @required Submission submission,
    @required List<CommentAngle> peerComments,
    this.homework,
  })  : _submission = submission,
        _peerComments = peerComments,
        super(key: key);

  final Submission _submission;
  final List<CommentAngle> _peerComments;
  final Homework homework;

  @override
  Widget build(BuildContext context) {
    _buildPeerComment(bool isFirstPeriodOfComment) {
      if (_peerComments.isNotEmpty) {
        return _peerComments.map((e) {
          if (e.isFirstPeriod == isFirstPeriodOfComment) {
            return ItemComRecieved(
              teaChecking: true,
              commentAngle: e,
              index: _peerComments.indexOf(e),
              submission: _submission,
            );
          } else {
            return Container();
          }
        }).toList();
      } else {
        return [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                '尚未收到来自同伴的评价。',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.grey),
              ),
            ),
          )
        ];
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoWithTitle(
                  title: '学生',
                  info: _submission.stuName,
                ),
                InfoWithTitle(
                  title: '学号',
                  info: _submission.stuID,
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            InfoWithTitle(
              title: '最后更改时间',
              info: _submission.updateAt.toString().split('.').first,
            ),
            SizedBox(
              height: 5.0,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '作业当前状态',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              HwStateText(
                hwState: homework.hwState,
              ),
            ]),
            Divider(),
            InfoWithTitle(
              title: '一稿',
              info: _submission.hwContent_1,
              helperText: _submission.hwContent_1 == '' ? '该同学没有提交一稿' : '',
            ),
            SizedBox(
              height: 5.0,
            ),
            Visibility(
              visible: _submission.hwContent_1 != '',
              child: Text(
                '收到的同伴评估',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Visibility(
              visible: _submission.hwContent_1 != '',
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _peerComments == null
                      ? [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        ]
                      : _buildPeerComment(true),
                ),
              ),
            ),
            Divider(),
            InfoWithTitle(
              title: '二稿',
              info: _submission.hwContent_2,
            ),
            SizedBox(
              height: 5.0,
            ),
            Visibility(
              visible: _submission.hwContent_1 != '',
              child: Text(
                '收到的同伴评估',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _peerComments == null
                    ? [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      ]
                    : _buildPeerComment(false),
              ),
            ),
            Divider(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            )
          ],
        ),
      ),
    );
  }
}

class InfoWithTitle extends StatelessWidget {
  final String title, info, helperText;

  const InfoWithTitle({Key key, this.title, this.info, this.helperText = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Visibility(
          visible: info != '',
          child: Text(
            info,
            textAlign: TextAlign.justify,
          ),
        ),
        Visibility(
          visible: helperText != '',
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              helperText,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
      ],
    );
  }
}
