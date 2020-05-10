import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:umengshare/umengshare.dart';

import 'image_banner.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
//     var appbar = AppBar(
// //      title: Text(widget.title),
//         );

    var body = SafeArea(
      top: true,
      child: Center(
          child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '邮箱',
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '密码',
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  FlatButton(
                    colorBrightness: Brightness.dark,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
//                    color: Color.fromARGB(220, 86, 119, 252),
                    color: Colors.cyan,
                    child: Text("登录"),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/signup');
                    },
//                    color: Color.fromARGB(200, 113, 247, 104),
                    color: Colors.tealAccent,
                    child: Text("注册"),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "忘记密码",
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.end,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 110,
                        child: Divider(
                          thickness: 1.0,
                          height: 1.0,
                          color: Colors.black45,
                        ),
                      ),
                      Text(
                        "第三方登录",
                        style: TextStyle(color: Colors.black45),
                      ),
                      Container(
                        width: 110,
                        child: Divider(
                          thickness: 1.0,
                          height: 1.0,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _thirdLogin(UMPlatform.Wechat);
                        },
//                        onTap: _thirdLogin(),
                        child: ImageBanner(
                            'assets/images/wechat_login.png', 50.0, 50.0),
                      ),
                      GestureDetector(
                        onTap: () {
                          _thirdLogin(UMPlatform.QQ);
                        },
//                        onTap: _thirdLogin(),
                        child: ImageBanner(
                            'assets/images/qq_login.png', 50.0, 50.0),
                      ),
                      GestureDetector(
                        onTap: () {
                          _thirdLogin(UMPlatform.Sina);
                        },
//                        onTap: _thirdLogin(),
                        child: ImageBanner(
                            'assets/images/sina_login.png', 50.0, 50.0),
                      ),
                    ],
                  ),
                ],
              ))),
    );

    return Scaffold(resizeToAvoidBottomPadding: false, body: body);
  }

  _login() {}

  _thirdLogin(UMPlatform umPlatform) {
//  _thirdLogin() {
    final response = UMengShare.login(umPlatform);
  }
}
