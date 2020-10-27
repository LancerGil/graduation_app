import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:graduationapp/screens/home/tab_user_bloc/index.dart';

class TabUserBlocBloc extends Bloc<TabUserBlocEvent, TabUserBlocState> {
  // todo: check singleton for logic in project
  // use GetIt for DI in projct
  static final TabUserBlocBloc _tabUserBlocBlocSingleton = TabUserBlocBloc._internal();
  factory TabUserBlocBloc() {
    return _tabUserBlocBlocSingleton;
  }
  TabUserBlocBloc._internal(): super(UnTabUserBlocState(0));
  
  @override
  Future<void> close() async{
    // dispose objects
    await super.close();
  }

  @override
  TabUserBlocState get initialState => UnTabUserBlocState(0);

  @override
  Stream<TabUserBlocState> mapEventToState(
    TabUserBlocEvent event,
  ) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'TabUserBlocBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
