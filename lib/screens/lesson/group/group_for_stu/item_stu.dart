import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graduationapp/models/stu_card.dart';

class ItemStuCard extends StatelessWidget {
  final LessonStu stu;

  ItemStuCard(this.stu);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 12.0,
          child: SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ClipRRect(
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(16.0)),
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Container(
                        color: Theme.of(context).primaryColor,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(stu.stuName),
                      Text(
                        stu.isLeader ? '组长' : ' ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontSize: 14.0),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Row(
                          children: <Widget>[
                            Text('学号: ${stu.stuNum}'),
                            Spacer(),
                            Text('作业均分: ${stu.stuAvgScore}')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
