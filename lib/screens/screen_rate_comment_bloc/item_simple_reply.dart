import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/shadow_container.dart';
import 'package:graduationapp/models/reply.dart';

class ItemSimpleReply extends StatelessWidget {
  const ItemSimpleReply({
    Key key,
    @required this.size,
    this.reply,
    this.fromMe,
  }) : super(key: key);

  final Size size;
  final Reply reply;
  final bool fromMe;

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      width: size.width,
      margin: const EdgeInsets.all(16),
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
                    '回评对象',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(fromMe ? reply.oppositeName : reply.myName),
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
                  Text(reply.updateAt.toString().split('.').first)
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
                  Text(reply.hwTitle),
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
                  Text(reply.lessonName)
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
                  Text(reply.oppositeName),
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
