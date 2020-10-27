import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/shadow_container.dart';
import 'package:graduationapp/models/comment_angle.dart';

class ItemSimpleComment extends StatelessWidget {
  const ItemSimpleComment({
    Key key,
    @required this.size,
    this.commentAngle,
    this.fromMe,
  }) : super(key: key);

  final Size size;
  final CommentAngle commentAngle;
  final bool fromMe;

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      width: size.width,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '点评对象',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(fromMe ? commentAngle.submiter : commentAngle.commenter),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '更新时间',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(commentAngle.updateAt.toString().split('.').first)
                ],
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '对应作业',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(commentAngle.homeworkTitle),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '所在班级',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(commentAngle.lessonName)
                ],
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '点评阶段',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(commentAngle.isFirstPeriod ? '一稿' : '二稿'),
                ],
              ),
              Spacer(),
              Text(
                '查看详情',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
