import 'package:flutter/material.dart';
import 'package:graduationapp/utils/firebase_auth.dart';

class SettingPage extends StatelessWidget {
  final VoidCallback logoutCallback;
  final BaseAuth auth;

  const SettingPage({Key key, this.logoutCallback, this.auth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appbar = AppBar(
      title: Text('设置'),
    );

    var body = Container(
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 8,
          ),
          Divider(
            height: 1,
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '个人信息',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
                  Text('更新你的昵称、邮箱和头像。',
                      style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    '安全与登录',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
                  Text('更改密码并采取其他措施来加固你的帐户安全。',
                      style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '权限设置',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
                  Text('允许app访问手机设备和信息。',
                      style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          SizedBox(
            height: 8.0,
          ),
          Divider(
            height: 1,
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '反馈、投诉和建议',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
                  Text('提供你的想法以帮助我们改善软件。',
                      style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '服务条款',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
//                  Text('更改密码并采取其他措施来加固你的帐户安全',
//                      style: Theme.of(context).textTheme.body2),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '数据使用政策',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
//                  Text('更改密码并采取其他措施来加固你的帐户安全',
//                      style: Theme.of(context).textTheme.body2),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Cookie政策',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
//                  Text('更改密码并采取其他措施来加固你的帐户安全',
//                      style: Theme.of(context).textTheme.body2),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '关于我们',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
//                  Text('更改密码并采取其他措施来加固你的帐户安全',
//                      style: Theme.of(context).textTheme.body2),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          SizedBox(
            height: 8.0,
          ),
          Divider(
            height: 1,
          ),
          GestureDetector(
            onTap: () {
              try {
                auth.signOut();
                logoutCallback();
                Navigator.of(context).pop();
              } catch (e) {
                print(e);
              }
            },
            child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(13.0),
                child: Text(
                  '退出当前帐号',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontWeight: FontWeight.w600, color: Colors.red),
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: appbar,
      body: body,
    );
  }
}
