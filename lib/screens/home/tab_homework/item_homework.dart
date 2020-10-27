import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/hw_state_text.dart';
import 'package:graduationapp/custom_widgets/inherited_auth.dart';
import 'package:graduationapp/models/hw_home.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/homework_details/for_tea.dart/screen_hw_detail_tea.dart';
import 'package:graduationapp/screens/homework_details/screen_hw_details.dart';
import 'package:intl/intl.dart';

class ItemHomeworkNow extends StatefulWidget {
  final Homework homework;

  ItemHomeworkNow(this.homework);

  @override
  _ItemHomeworkNowState createState() => _ItemHomeworkNowState();
}

class _ItemHomeworkNowState extends State<ItemHomeworkNow> {
  double horizontalMargin, itemWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final doneStu = widget.homework.hwDoneStu;
    var homework = widget.homework;
    User user = InheritedAuth.of(context).user;
    horizontalMargin = MediaQuery.of(context).size.width * 0.03;
    MapEntry currentStatus = widget.homework.getCurrentStatus();

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => user.identity == "teacher"
                    ? HwDetailForTeaPage(homework: homework, user: user)
                    : HomeworkPage(homework: homework, user: user)));
      },
      child: Card(
          margin:
              EdgeInsets.fromLTRB(horizontalMargin, 10, horizontalMargin, 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 15.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.3,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                          height: MediaQuery.of(context).size.width * 0.3,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Image.asset(
                            widget.homework.hwAssetPath,
                            fit: BoxFit.cover,
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '作业标题',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.56,
                                child: Text(
                                  widget.homework.hwTitle,
                                  style: Theme.of(context).textTheme.subtitle2,
                                  maxLines: 2,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '课程',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(widget.homework.lessonName),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              HwStateText(hwState: currentStatus.key),
                              Text(
                                currentStatus.value == null
                                    ? '  -  已截止'
                                    : DateFormat('  -  MM-dd截止')
                                        .format(currentStatus.value),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.indigoAccent),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                '$doneStu',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.lightGreen),
                              ),
                              Text('人已提交',
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
