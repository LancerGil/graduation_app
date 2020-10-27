import 'package:equatable/equatable.dart';
import 'package:graduationapp/models/comment_angle.dart';
import 'package:graduationapp/models/reply.dart';

abstract class ScreenRateCommentBlocState extends Equatable {
  /// notify change state without deep clone state
  final int version;

  final List propss;
  ScreenRateCommentBlocState(this.version, [this.propss]);

  /// Copy object for use in action
  /// if need use deep clone
  ScreenRateCommentBlocState getStateCopy();

  ScreenRateCommentBlocState getNewVersion();

  @override
  List<Object> get props => ([version, ...propss ?? []]);
}

/// UnInitialized
class UnScreenRateCommentBlocState extends ScreenRateCommentBlocState {
  UnScreenRateCommentBlocState(int version) : super(version);

  @override
  String toString() => 'UnScreenRateCommentBlocState';

  @override
  UnScreenRateCommentBlocState getStateCopy() {
    return UnScreenRateCommentBlocState(0);
  }

  @override
  UnScreenRateCommentBlocState getNewVersion() {
    return UnScreenRateCommentBlocState(version + 1);
  }
}

/// Initialized
class InScreenReplyBlocState extends ScreenRateCommentBlocState {
  final List<Reply> replies;

  InScreenReplyBlocState(
    int version,
    this.replies,
  ) : super(version);

  @override
  String toString() => 'InScreenRateCommentBlocState $version';

  @override
  InScreenReplyBlocState getStateCopy() {
    return InScreenReplyBlocState(version, replies);
  }

  @override
  InScreenReplyBlocState getNewVersion() {
    return InScreenReplyBlocState(version + 1, replies);
  }
}

class InScreenCommentBlocState extends ScreenRateCommentBlocState {
  final List<CommentAngle> replies;

  InScreenCommentBlocState(
    int version,
    this.replies,
  ) : super(version);

  @override
  String toString() => 'InScreenRateCommentBlocState $version';

  @override
  InScreenCommentBlocState getStateCopy() {
    return InScreenCommentBlocState(version, replies);
  }

  @override
  InScreenCommentBlocState getNewVersion() {
    return InScreenCommentBlocState(version + 1, replies);
  }
}

class ErrorScreenRateCommentBlocState extends ScreenRateCommentBlocState {
  final String errorMessage;

  ErrorScreenRateCommentBlocState(int version, this.errorMessage)
      : super(version, [errorMessage]);

  @override
  String toString() => 'ErrorScreenRateCommentBlocState';

  @override
  ErrorScreenRateCommentBlocState getStateCopy() {
    return ErrorScreenRateCommentBlocState(version, errorMessage);
  }

  @override
  ErrorScreenRateCommentBlocState getNewVersion() {
    return ErrorScreenRateCommentBlocState(version + 1, errorMessage);
  }
}
