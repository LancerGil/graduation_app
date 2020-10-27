import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationapp/models/index.dart';
import 'package:graduationapp/screens/screen_rate_comment_bloc/index.dart';

class ScreenRateCommentBlocScreen extends StatefulWidget {
  const ScreenRateCommentBlocScreen({
    Key key,
    @required ScreenRateCommentBloc screenRateCommentBlocBloc,
    @required User user,
    @required bool fromMe,
    @required bool isReply,
  })  : _screenRateCommentBloc = screenRateCommentBlocBloc,
        _user = user,
        _fromMe = fromMe,
        _isReply = isReply,
        super(key: key);

  final ScreenRateCommentBloc _screenRateCommentBloc;
  final User _user;
  final bool _fromMe, _isReply;

  @override
  ScreenRateCommentBlocScreenState createState() {
    return ScreenRateCommentBlocScreenState();
  }
}

class ScreenRateCommentBlocScreenState
    extends State<ScreenRateCommentBlocScreen> {
  ScreenRateCommentBlocScreenState();

  @override
  void initState() {
    super.initState();
    _load(widget._isReply);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<ScreenRateCommentBloc, ScreenRateCommentBlocState>(
        cubit: widget._screenRateCommentBloc,
        builder: (
          BuildContext context,
          ScreenRateCommentBlocState currentState,
        ) {
          if (currentState is UnScreenRateCommentBlocState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorScreenRateCommentBlocState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage ?? 'Error'),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text('reload'),
                    onPressed: () {
                      _load(widget._isReply);
                    },
                  ),
                ),
              ],
            ));
          }
          if (currentState is InScreenReplyBlocState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    ...currentState.replies
                        .map((e) => ItemSimpleReply(
                              size: size,
                              reply: e,
                              fromMe: widget._fromMe,
                            ))
                        .toList(),
                  ],
                ),
              ),
            );
          }
          if (currentState is InScreenCommentBlocState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    ...currentState.replies
                        .map((e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: ItemSimpleComment(
                                size: size,
                                commentAngle: e,
                                fromMe: widget._fromMe,
                              ),
                            ))
                        .toList(),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _load(bool isReply) {
    if (isReply)
      widget._screenRateCommentBloc
          .add(LoadReplyBlocEvent(widget._user, widget._fromMe));
    else
      widget._screenRateCommentBloc
          .add(LoadCommentBlocEvent(widget._user, widget._fromMe));
  }
}
