import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/inherited_auth.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/home/item_history_lesson.dart';
import 'package:graduationapp/screens/home/tab_user/screen_rate_comm.dart';
import 'package:graduationapp/screens/setting/screen_setting_menu.dart';
import 'package:graduationapp/utils/firebase_auth.dart';

import '../search_delegate.dart';

const List<String> MENU_LIST = [
  '我的评分',
  '收到评分',
  '我的回评',
  '收到回评',
];

class TabUserPage extends StatefulWidget {
  @override
  _TabUserPageState createState() => _TabUserPageState();
}

class _TabUserPageState extends State<TabUserPage> {
  int _numReplied = 2;
  int _numRated = 0;
  User user;

  @override
  Widget build(BuildContext context) {
    final BaseAuth auth = InheritedAuth.of(context).auth;
    final VoidCallback logoutCallback =
        InheritedAuth.of(context).loggoutCallback;
    user = InheritedAuth.of(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('${user.fullname}'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingPage(
                      auth: auth,
                      logoutCallback: logoutCallback,
                    ),
                  ),
                );
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            SizedBox(
              height: 55,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withAlpha(150),
                          offset: Offset(0, 8),
                          blurRadius: 10.0)
                    ],
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(15.0))),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 88.0,
                    width: 88.0,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withAlpha(150),
                            offset: Offset(0, 8),
                            blurRadius: 10.0)
                      ],
                      border: Border.all(width: 3, color: Colors.white),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/nezuko2.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    '${user.identity}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Divider(
                    thickness: 1.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '所有课程',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      GestureDetector(
                        onTap: () {
                          showSearch(
                            context: context,
                            delegate: CustomSearchDelegate(
                              LessonNow.fetchAll(LessonNow.classID),
                              user,
                            ),
                          );
                        },
                        child: Text(
                          '搜索课程',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '11',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        '门课程',
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 340,
                    child: GridView.count(
                      // crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      // childAspectRatio: 11 / 8,
                      crossAxisCount: 2,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      children: List.generate(11, (index) {
                        return HistoryLesson(
                            LessonNow.fetchAll(LessonNow.classID)[index]);
                      }),
                    ),
                  ),
                  Divider(
                    thickness: 1.0,
                  ),
                  Column(
                    children: _buildReviewReplyList(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildReviewReplyList() {
    return MENU_LIST
        .map(
          (f) => Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RateCommentPage(
                                screenTitle: f,
                              )));
                },
                child: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        f,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.5),
                      ),
                      Row(
                        children: <Widget>[
                          Visibility(
                            visible:
                                _numReplied > 0 && MENU_LIST.indexOf(f) % 2 != 0
                                    ? true
                                    : false,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 20.0,
                                  width: 20.0,
                                  color: Colors.red,
                                  child: Text(
                                    MENU_LIST.indexOf(f) == 1
                                        ? '$_numRated'
                                        : '$_numReplied',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(color: Colors.white),
                                  )),
                            ),
                          ),
                          Icon(CupertinoIcons.right_chevron)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 1.0,
              ),
            ],
          ),
        )
        .toList();
  }
}
