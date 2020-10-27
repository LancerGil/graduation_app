import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/inherited_auth.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/home/tab_user_bloc/index.dart';
import 'package:graduationapp/utils/firebase_auth.dart';

class TabUserBlocPage extends StatefulWidget {
  static const String routeName = '/tabUserBloc';
  final User user;

  const TabUserBlocPage({Key key, this.user}) : super(key: key);

  @override
  _TabUserBlocPageState createState() => _TabUserBlocPageState();
}

class _TabUserBlocPageState extends State<TabUserBlocPage> {
  final _tabUserBlocBloc = TabUserBlocBloc();

  @override
  Widget build(BuildContext context) {
    final BaseAuth auth = InheritedAuth.of(context).auth;
    final VoidCallback logoutCallback =
        InheritedAuth.of(context).loggoutCallback;
    return Scaffold(
      appBar: AppBar(
        title: Text('个人页面'),
        actions: [
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings', arguments: {
                  'auth': auth,
                  'logout': logoutCallback,
                });
              })
        ],
      ),
      body: TabUserBlocScreen(
        tabUserBlocBloc: _tabUserBlocBloc,
        user: widget.user,
      ),
    );
  }
}
