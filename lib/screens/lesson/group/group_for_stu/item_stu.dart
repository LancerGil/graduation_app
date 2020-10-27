import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graduationapp/models/lesson_stu.dart';

class ItemStuCard extends StatelessWidget {
  final LessonStu stu;

  ItemStuCard(this.stu);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03, vertical: 5),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 12.0,
          child: SizedBox(
            height: MediaQuery.of(context).size.width * 0.3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ClipRRect(
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(16.0)),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width * 0.3,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Image.asset(
                        stu.stuImagePath,
                        fit: BoxFit.cover,
                      ),
                    )),
                Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
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
                      Text('学号: ${stu.stuNum}'),
                      Text('作业均分: ${stu.stuAvgScore}')
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
