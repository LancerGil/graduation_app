import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:graduationapp/screens/setting/screen_change_pwd/index.dart';

class ScreenChangePwdBloc extends Bloc<ScreenChangePwdEvent, ScreenChangePwdState> {

  ScreenChangePwdBloc(ScreenChangePwdState initialState) : super(initialState);

  @override
  Stream<ScreenChangePwdState> mapEventToState(
    ScreenChangePwdEvent event,
  ) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'ScreenChangePwdBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
