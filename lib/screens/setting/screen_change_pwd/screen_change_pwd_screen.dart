import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationapp/screens/setting/screen_change_pwd/body_change_pwd_form.dart';
import 'package:graduationapp/screens/setting/screen_change_pwd/index.dart';
import 'package:graduationapp/utils/firebase_auth.dart';
import 'package:graduationapp/utils/flutter_toast.dart';

class ScreenChangePwdScreen extends StatefulWidget {
  const ScreenChangePwdScreen({
    Key key,
    @required ScreenChangePwdBloc screenChangePwdBloc,
  })  : _screenChangePwdBloc = screenChangePwdBloc,
        super(key: key);

  final ScreenChangePwdBloc _screenChangePwdBloc;

  @override
  ScreenChangePwdScreenState createState() {
    return ScreenChangePwdScreenState();
  }
}

class ScreenChangePwdScreenState extends State<ScreenChangePwdScreen> {
  ScreenChangePwdScreenState();
  FirebaseUser firebaseUser;
  static const ERROR_WRONG_PASSWORD = 'ERROR_WRONG_PASSWORD';
  bool ifHidePwd = true;

  TextEditingController reauthController;

  getCurrentUser() async {
    firebaseUser = await MyAuth().getCurrentUser();
  }

  @override
  void initState() {
    getCurrentUser();
    reauthController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    reauthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreenChangePwdBloc, ScreenChangePwdState>(
      cubit: widget._screenChangePwdBloc,
      builder: (
        BuildContext context,
        ScreenChangePwdState currentState,
      ) {
        if (currentState is UnScreenChangePwdState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (currentState is ErrorScreenChangePwdState) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                currentState.errorMessage == ERROR_WRONG_PASSWORD
                    ? "密码错误,请返回重试"
                    : currentState.errorMessage ?? 'Error',
                style: TextStyle(color: Colors.red),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: Theme.of(context).primaryColor,
                  onPressed: blocBackToReauth,
                  child: Text(
                    '返回',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ));
        }
        if (currentState is InScreenChangePwdState) {
          return BodyChangePwd(
            currentState: currentState,
            submit: blocReauth,
            forgetPwd: blocForgetPwd,
          );
        }
        if (currentState is ClearToChangePwdState) {
          return BodyChangePwd(
            currentState: currentState,
            submit: blocChangePwd,
          );
        }
        if (currentState is ChangePwdSucceedState) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Text('修改成功'),
                SizedBox(
                  height: 30,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '返回',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
        }
        if (currentState is ForgotPwdState) {
          return BodyChangePwd(
            submit: handleSubmitResetRequest,
            currentState: currentState,
          );
        }
        if (currentState is HaveSendEmailToResetPwdState) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Text('发送成功,请检查您的邮箱'),
                SizedBox(
                  height: 30,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '返回',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  blocBackToReauth() {
    widget._screenChangePwdBloc.add(InScreenChangePwdEvent());
  }

  blocReauth(String pwd) {
    widget._screenChangePwdBloc.add(
      ReauthEvent(firebaseUser.email, pwd),
    );
  }

  blocChangePwd(String pwd) {
    widget._screenChangePwdBloc.add(ChangePwdEvent(pwd));
  }

  blocSendEmailToResetPwd() {
    widget._screenChangePwdBloc.add(SendEmailToResetPwdEvent());
  }

  blocForgetPwd() {
    widget._screenChangePwdBloc.add(ForgotPwdEvent());
  }

  blocSendResetEmail() {
    widget._screenChangePwdBloc.add(SendEmailToResetPwdEvent());
  }

  handleSubmitResetRequest(String email) {
    if (email == firebaseUser.email) {
      blocSendEmailToResetPwd();
    } else {
      MyFlutterToast.showToast('输入邮箱与注册邮箱不一致', context);
    }
  }

  // backToSetPwd(){
  //   widget._screenChangePwdBloc.add(event)
  // }
}
