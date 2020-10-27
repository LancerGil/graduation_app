import 'package:flutter/material.dart';
import 'package:graduationapp/screens/setting/screen_change_pwd/index.dart';

class ScreenChangePwdPage extends StatefulWidget {
  static const String routeName = '/screenChangePwd';

  @override
  _ScreenChangePwdPageState createState() => _ScreenChangePwdPageState();
}

class _ScreenChangePwdPageState extends State<ScreenChangePwdPage> {
  final _screenChangePwdBloc = ScreenChangePwdBloc(InScreenChangePwdState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('更改密码'),
      ),
      body: ScreenChangePwdScreen(screenChangePwdBloc: _screenChangePwdBloc),
    );
  }
}

// class ScreenChangePwdPage extends StatelessWidget {
//     final _screenChangePwdBloc = ScreenChangePwdBloc(InScreenChangePwdState());

//   @override
//   Widget build(BuildContext context) {
//      return Scaffold(
//       appBar: AppBar(
//         title: Text('更改密码'),
//       ),
//       body: ScreenChangePwdScreen(screenChangePwdBloc: _screenChangePwdBloc),
//     );
//   }
// }
