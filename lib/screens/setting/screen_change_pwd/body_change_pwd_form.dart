import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/animated_icon.dart';

import 'index.dart';

class BodyChangePwd extends StatefulWidget {
  const BodyChangePwd({
    Key key,
    @required this.submit,
    @required this.currentState,
    this.forgetPwd,
  }) : super(key: key);

  final Function submit, forgetPwd;
  final ScreenChangePwdState currentState;

  @override
  _BodyChangePwdState createState() => _BodyChangePwdState();
}

class _BodyChangePwdState extends State<BodyChangePwd> {
  var _formKey;
  bool ifHidePwd = true, ifShowForgetPwd = true, ifSHowSuffixIcon = true;
  TextEditingController controller;
  String title = '身份验证';
  String hint = '更改密码之前,请先验证你的身份';
  String label = '当前密码';

  validate() {
    if (_formKey.currentState.validate()) {
      print('validate true');
      widget.submit(controller.text);
    }
  }

  toggleShowPwd() {
    setState(() {
      ifHidePwd = !ifHidePwd;
    });
  }

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    controller = TextEditingController();
    if (widget.currentState is ClearToChangePwdState) {
      title = '更改密码';
      hint = '输入你的新密码,请确保输入无误';
      label = '新密码';
      ifShowForgetPwd = false;
    }
    if (widget.currentState is ForgotPwdState) {
      title = '重置密码';
      hint = '确保我们将重置密码邮件发送到正确的邮箱';
      label = '确认您的邮箱';
      ifShowForgetPwd = false;
      ifHidePwd = false;
      ifSHowSuffixIcon = false;
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.currentState);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(
            hint,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(
                suffixIcon: ifSHowSuffixIcon
                    ? AnimatedIconButton(
                        size: 20,
                        showInitAsDefault: ifHidePwd,
                        initalIcon: Icons.remove_red_eye_outlined,
                        anotherIcon: Icons.remove_red_eye,
                        doSomeThing: toggleShowPwd,
                      )
                    : null,
              ),
              keyboardType: TextInputType.text,
              obscureText: ifHidePwd,
              controller: controller,
            ),
          ),
          Visibility(
            visible: ifShowForgetPwd,
            child: GestureDetector(
              onTap: widget.forgetPwd ??
                  () {
                    print('forgetPwd is null');
                  },
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '忘记密码?',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.blue),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              validate();
            },
            child: Text(
              '确认',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
