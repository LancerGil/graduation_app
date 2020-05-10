import 'package:flutter/material.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/utils/firebase_userinfo.dart';

///Sign up page
class SignUpPage extends StatefulWidget {
  final FireBaseUserInfor fireBaseUserInfor;
  final String userId;
  final VoidCallback loginCallback;

  const SignUpPage({
    Key key,
    this.fireBaseUserInfor,
    this.userId,
    this.loginCallback,
  }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  String _identity = "teacher";
  TextEditingController _realNameCon;
  TextEditingController _stuIDCon;
  bool isFilled = false;

  @override
  void initState() {
    super.initState();
    _realNameCon = TextEditingController();
    _stuIDCon = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _realNameCon.dispose();
    _stuIDCon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appbar = AppBar(
      title: Text('个人信息'),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.check,
              color: isFilled ? Colors.greenAccent : Colors.grey,
            ),
            onPressed: !isFilled
                ? null
                : () {
                    setUerInfor();
                  })
      ],
    );

    var body = Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            TextField(
              onChanged: (text) {
                setState(() {
                  isFilled = ifFilled();
                });
              },
              controller: _realNameCon,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '真实姓名',
                  helperText: "课程中需使用真实姓名"),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Radio(
                value: "teacher",
                groupValue: _identity,
                onChanged: (value) {
                  onChanged(value);
                },
              ),
              Text(
                '教师',
                style: TextStyle(fontSize: 16.0),
              ),
              Radio(
                value: "student",
                groupValue: _identity,
                onChanged: (value) {
                  onChanged(value);
                },
              ),
              Text(
                '学生',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ]),
            AnimatedSize(
              curve: Curves.easeOutCirc,
              duration: Duration(milliseconds: 500),
              vsync: this,
              child: Visibility(
                visible: _identity == "student",
                child: TextField(
                  onChanged: (text) {
                    setState(() {
                      isFilled = ifFilled();
                    });
                  },
                  controller: _stuIDCon,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '学号',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: appbar,
      body: body,
    );
  }

  void onChanged(String value) {
    setState(() {
      _identity = value;
    });

    print('Value = $value');
  }

  ifFilled() {
    if (_realNameCon.text.length == 0 || _realNameCon.text == null) {
      return false;
    }
    if (_identity == "student" &&
        (_stuIDCon.text.length == 0 || _stuIDCon.text == null)) {
      return false;
    }
    return true;
  }

  void setUerInfor() {
    User userInfor = User();
    userInfor.setFullname(_realNameCon.text);
    userInfor.setIdentity(_identity);
    userInfor.setStuID(_stuIDCon.text);
    userInfor.setUserId(widget.userId);
    widget.fireBaseUserInfor.createUserInfor(userInfor);

    widget.loginCallback();
  }
}
