import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/animated_size.dart';
import 'package:graduationapp/custom_widgets/shadow_container.dart';
import 'package:graduationapp/models/comment_angle.dart';
import 'package:graduationapp/models/submission.dart';
import 'package:graduationapp/screens/homework_details/peer_comment/item_comment_angle.dart';

import 'comment_one_angle.dart';

class BodyPeerCommentFromAngle extends StatefulWidget {
  const BodyPeerCommentFromAngle({
    Key key,
    this.isFirstPeriodOfComment,
    this.updateCommentList,
    this.commentFromEachAngle,
    this.submission,
  }) : super(key: key);

  final bool isFirstPeriodOfComment;
  final Function updateCommentList;
  final List<CommentOfOneAngle> commentFromEachAngle;
  final Submission submission;

  @override
  _BodyPeerCommentFromAngleState createState() =>
      _BodyPeerCommentFromAngleState();
}

class _BodyPeerCommentFromAngleState extends State<BodyPeerCommentFromAngle> {
  bool folded = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> buildCommentForm() {
      print('buildCommentForm');
      List<Widget> result = [];
      for (int i = 0; i < CommentAngle.ANGLE.length; i++) {
        result.add(ItemCommentFromAngle(
          size: size,
          index: i,
          angle: CommentAngle.ANGLE[i],
          angleIntro: CommentAngle.ANGLEINTRO[i],
          updateCommentList: widget.updateCommentList,
          commentOfOneAngle: widget.commentFromEachAngle[i],
        ));
      }
      return result;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${widget.submission.stuName}的作业',
                ),
                Spacer(),
                Text(
                  widget.isFirstPeriodOfComment ? '一稿' : '二稿',
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              '作业内容',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              height: 5,
            ),
            ShadowContainer(
              width: size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            folded = !folded;
                          });
                        },
                        child: Text(
                          folded ? '展开' : '收起',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Colors.blue),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width,
                      child: MyAnimatedSize(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeOutCirc,
                        child: Text(
                          widget.submission.hwContent_2.isEmpty
                              ? widget.submission.hwContent_1
                              : widget.isFirstPeriodOfComment
                                  ? widget.submission.hwContent_1
                                  : widget.submission.hwContent_2,
                          maxLines: folded ? 2 : null,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              '我的点评',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ]..addAll(buildCommentForm()),
        ),
      ),
    );
  }
}
