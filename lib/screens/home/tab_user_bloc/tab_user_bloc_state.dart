import 'package:equatable/equatable.dart';
import 'package:graduationapp/models/lesson_home.dart';

abstract class TabUserBlocState extends Equatable {
  /// notify change state without deep clone state
  final int version;

  final List propss;
  TabUserBlocState(this.version, [this.propss]);

  /// Copy object for use in action
  /// if need use deep clone
  TabUserBlocState getStateCopy();

  TabUserBlocState getNewVersion();

  @override
  List<Object> get props => ([version, ...propss ?? []]);
}

/// UnInitialized
class UnTabUserBlocState extends TabUserBlocState {
  UnTabUserBlocState(int version) : super(version);

  @override
  String toString() => 'UnTabUserBlocState';

  @override
  UnTabUserBlocState getStateCopy() {
    return UnTabUserBlocState(0);
  }

  @override
  UnTabUserBlocState getNewVersion() {
    return UnTabUserBlocState(version + 1);
  }
}

/// Initialized
class InTabUserBlocState extends TabUserBlocState {
  final List<Lesson> lessonList;

  InTabUserBlocState(int version, this.lessonList) : super(version);

  @override
  String toString() => 'InTabUserBlocState $version';

  @override
  InTabUserBlocState getStateCopy() {
    return InTabUserBlocState(version, lessonList);
  }

  @override
  InTabUserBlocState getNewVersion() {
    return InTabUserBlocState(version + 1, lessonList);
  }
}

class ErrorTabUserBlocState extends TabUserBlocState {
  final String errorMessage;

  ErrorTabUserBlocState(int version, this.errorMessage)
      : super(version, [errorMessage]);

  @override
  String toString() => 'ErrorTabUserBlocState';

  @override
  ErrorTabUserBlocState getStateCopy() {
    return ErrorTabUserBlocState(version, errorMessage);
  }

  @override
  ErrorTabUserBlocState getNewVersion() {
    return ErrorTabUserBlocState(version + 1, errorMessage);
  }
}
