import 'dart:async';
import 'dart:developer' as developer;

import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/repository/lesson_repository.dart';
import 'package:graduationapp/screens/home/tab_user_bloc/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TabUserBlocEvent {
  Stream<TabUserBlocState> applyAsync(
      {TabUserBlocState currentState, TabUserBlocBloc bloc});
  final BaseLessonRepository _tabUserBlocRepository = LessonRepository();
}

class UnTabUserBlocEvent extends TabUserBlocEvent {
  @override
  Stream<TabUserBlocState> applyAsync(
      {TabUserBlocState currentState, TabUserBlocBloc bloc}) async* {
    yield UnTabUserBlocState(0);
  }
}

class LoadLessonBlocEvent extends TabUserBlocEvent {
  final User user;

  @override
  String toString() => 'LoadTabUserBlocEvent';

  LoadLessonBlocEvent(this.user);

  @override
  Stream<TabUserBlocState> applyAsync(
      {TabUserBlocState currentState, TabUserBlocBloc bloc}) async* {
    try {
      yield UnTabUserBlocState(0);
      List<Lesson> lessonList = await _tabUserBlocRepository.checkLesson(user);
      yield InTabUserBlocState(0, lessonList);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadTabUserBlocEvent', error: _, stackTrace: stackTrace);
      yield ErrorTabUserBlocState(0, _?.toString());
    }
  }
}
