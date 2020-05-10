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
  final HwAtHome hwAtHome;

  ItemHomeworkNow(this.hwAtHome);

  @override
  _ItemHomeworkNowState createState() => _ItemHomeworkNowState();
}

class _ItemHomeworkNowState extends State<ItemHomeworkNow> {
  @override
  Widget build(BuildContext context) {
    final doneStu = widget.hwAtHome.hwDoneStu;
    var homework = widget.hwAtHome;
    User user = InheritedAuth.of(context).user;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => user.identity == "teacher"
                    ? HwDetailForTeaPage(homework: homework)
                    : HomeworkPage(homework: homework)));
      },
      child: Card(
          margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
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
                          height: 120,
                          width: 120,
                          child: Image.asset(
                            widget.hwAtHome.hwAssetPath,
                            fit: BoxFit.cover,
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              widget.hwAtHome.hwTitle,
                              style: Theme.of(context).textTheme.subtitle2,
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(widget.hwAtHome.hwLesson),
                              SizedBox(
                                width: 20.0,
                              ),
                              HwStateText(hwState: widget.hwAtHome.hwState),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                DateFormat('MM-dd')
                                    .format(widget.hwAtHome.ddl[0]),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.indigoAccent),
                              ),
                              Text('截止',
                                  style: Theme.of(context).textTheme.bodyText1),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                '$doneStu',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.lightGreen),
                              ),
                              Text('人已完成',
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // GestureDetector(
              //     child: Icon(CupertinoIcons.right_chevron), onTap: () {})
            ],
          )),
    );
  }
}
