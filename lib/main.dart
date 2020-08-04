import 'package:flutter/material.dart';
import 'package:graduationapp/models/app_model.dart';
import 'package:graduationapp/screen_root.dart';
import 'package:graduationapp/screens/home/tab_user/screen_rate_comm.dart';
import 'package:graduationapp/screens/homework_details/for_tea.dart/screen_hw_detail_tea.dart';
import 'package:scoped_model/scoped_model.dart';

import 'screens/home/screen_home.dart';
import 'screens/home/tab_lesson/screen_create_lesson.dart';
import 'screens/homework_details/create_hw.dart';
import 'screens/lesson/group/group_for_stu/sceen_choose.dart';
import 'screens/login/screen_login.dart';
import 'screens/setting/screen_setting_menu.dart';
import 'screens/sign_up/update_user_info.dart';
import 'style.dart';
import 'utils/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: new AppModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            dividerTheme: DividerThemeData(thickness: 1),
            primaryColor: Color(0xFF162A49),
            appBarTheme: AppBarTheme(
                elevation: 0.0,
                color: Colors.white,
                iconTheme: IconThemeData(color: Colors.grey),
                textTheme: TextTheme(headline6: AppBarTextStyle)),
            textTheme: TextTheme(
              headline6: TitleTextStyle,
              subtitle2: SubtitleTextStyle,
              bodyText2: Body1TextStyle,
              bodyText1: Body2TextStyle,
              headline4: ClickableTextStyle,
            ),
            primaryIconTheme: IconThemeData(color: Colors.white),
            buttonTheme: ButtonThemeData(
                height: 45.0, buttonColor: Theme.of(context).primaryColor)),
        initialRoute: '/root',
        routes: {
          '/root': (context) => RootPage(auth: new Auth()),
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignUpPage(),
          '/settings': (context) => SettingPage(),
          '/homework': (context) => HomePage(),
          '/r_and_c': (context) => RateCommentPage(),
          '/createHw': (context) => CreateHWPage(),
          '/choose': (context) => ChoosePage(),
          '/createLesson': (context) => CreateLessonPage(),
          '/hwFromTea': (context) => HwDetailForTeaPage(),
        },
      ),
    );
  }
}
