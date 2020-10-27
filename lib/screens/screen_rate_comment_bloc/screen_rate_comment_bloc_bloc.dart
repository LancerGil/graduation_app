import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:graduationapp/screens/screen_rate_comment_bloc/index.dart';

class ScreenRateCommentBloc
    extends Bloc<ScreenRateCommentBlocEvent, ScreenRateCommentBlocState> {
  // todo: check singleton for logic in project
  // use GetIt for DI in projct
  static final ScreenRateCommentBloc _screenRateCommentBlocBlocSingleton =
      ScreenRateCommentBloc._internal();
  factory ScreenRateCommentBloc() {
    return _screenRateCommentBlocBlocSingleton;
  }
  ScreenRateCommentBloc._internal() : super(UnScreenRateCommentBlocState(0));

  @override
  Future<void> close() async {
    // dispose objects
    await super.close();
  }

  @override
  ScreenRateCommentBlocState get initialState =>
      UnScreenRateCommentBlocState(0);

  @override
  Stream<ScreenRateCommentBlocState> mapEventToState(
    ScreenRateCommentBlocEvent event,
  ) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'ScreenRateCommentBlocBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
