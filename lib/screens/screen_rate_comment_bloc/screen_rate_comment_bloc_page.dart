import 'package:flutter/material.dart';
import 'package:graduationapp/screens/screen_rate_comment_bloc/index.dart';

class RateCommentBlocPage extends StatefulWidget {
  static const String routeName = '/screenRateCommentBloc';

  @override
  _RateCommentBlocPageState createState() => _RateCommentBlocPageState();
}

class _RateCommentBlocPageState extends State<RateCommentBlocPage> {
  final _screenRateCommentBloc = ScreenRateCommentBloc();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    bool fromMe = args['title'].contains('我');
    bool isReply = args['title'].contains('回评');
    return Scaffold(
      appBar: AppBar(
        title: Text(args['title']),
      ),
      body: ScreenRateCommentBlocScreen(
        screenRateCommentBlocBloc: _screenRateCommentBloc,
        fromMe: fromMe,
        user: args['user'],
        isReply: isReply,
      ),
    );
  }
}
