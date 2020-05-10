import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/inherited_auth.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/home/screen_home.dart';
import 'package:graduationapp/screens/login/screen_login_signup.dart';
import 'package:graduationapp/screens/sign_up/update_user_info.dart';
import 'package:graduationapp/utils/firebase_userinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/firebase_auth.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  getSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text('正在登录...'),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignupPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          BaseUserInfo fireBaseUserInfor = FireBaseUserInfor(_userId);
          return FutureBuilder<QuerySnapshot>(
              future: fireBaseUserInfor.getUserExtraInfor(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return buildWaitingScreen();
                } else if (snapshot.hasData) {
                  if (snapshot.data.documents.length == 0) {
                    return new SignUpPage(
                      fireBaseUserInfor: fireBaseUserInfor,
                      userId: _userId,
                      loginCallback: loginCallback,
                    );
                  } else {
                    return InheritedAuth(
                      auth: widget.auth,
                      user: User.fromSnapshot(snapshot.data),
                      loggoutCallback: logoutCallback,
                      child: new HomePage(),
                    );
                  }
                } else {
                  return buildWaitingScreen();
                }
              });
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
