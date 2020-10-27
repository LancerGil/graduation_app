import 'dart:async';
import 'dart:developer' as developer;

import 'package:graduationapp/models/comment_angle.dart';
import 'package:graduationapp/models/index.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/repository/comment_repo.dart';
import 'package:graduationapp/repository/reply_repo.dart';
import 'package:graduationapp/screens/screen_rate_comment_bloc/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ScreenRateCommentBlocEvent {
  Stream<ScreenRateCommentBlocState> applyAsync(
      {ScreenRateCommentBlocState currentState, ScreenRateCommentBloc bloc});
  final BaseReplyRepository _screenReplyBlocRepository = ReplyRepository();
  final BaseCommentRepository _screenCommentBlocRepository =
      CommentRepository();
}

class UnScreenRateCommentBlocEvent extends ScreenRateCommentBlocEvent {
  @override
  Stream<ScreenRateCommentBlocState> applyAsync(
      {ScreenRateCommentBlocState currentState,
      ScreenRateCommentBloc bloc}) async* {
    yield UnScreenRateCommentBlocState(0);
  }
}

class LoadCommentBlocEvent extends ScreenRateCommentBlocEvent {
  final User user;
  final bool fromMe;
  @override
  String toString() => 'LoadScreenRateCommentBlocEvent';

  LoadCommentBlocEvent(this.user, this.fromMe);

  @override
  Stream<ScreenRateCommentBlocState> applyAsync(
      {ScreenRateCommentBlocState currentState,
      ScreenRateCommentBloc bloc}) async* {
    try {
      yield UnScreenRateCommentBlocState(0);
      await Future.delayed(Duration(seconds: 1));
      List<CommentAngle> comments =
          await _screenCommentBlocRepository.checkComments(user, fromMe);
      yield InScreenCommentBlocState(0, comments);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadScreenCommentBlocEvent', error: _, stackTrace: stackTrace);
      yield ErrorScreenRateCommentBlocState(0, _?.toString());
    }
  }
}

class LoadReplyBlocEvent extends ScreenRateCommentBlocEvent {
  final User user;
  final bool fromMe;
  @override
  String toString() => 'LoadScreenRateCommentBlocEvent';

  LoadReplyBlocEvent(this.user, this.fromMe);

  @override
  Stream<ScreenRateCommentBlocState> applyAsync(
      {ScreenRateCommentBlocState currentState,
      ScreenRateCommentBloc bloc}) async* {
    try {
      yield UnScreenRateCommentBlocState(0);
      await Future.delayed(Duration(seconds: 1));
      List<Reply> replies =
          await _screenReplyBlocRepository.checkReply(user, fromMe);
      yield InScreenReplyBlocState(0, replies);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadScreenReplyBlocEvent', error: _, stackTrace: stackTrace);
      yield ErrorScreenRateCommentBlocState(0, _?.toString());
    }
  }
}
