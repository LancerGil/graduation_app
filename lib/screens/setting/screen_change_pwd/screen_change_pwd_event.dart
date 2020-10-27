import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:graduationapp/screens/setting/screen_change_pwd/index.dart';
import 'package:graduationapp/utils/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ScreenChangePwdEvent {
  Stream<ScreenChangePwdState> applyAsync(
      {ScreenChangePwdState currentState, ScreenChangePwdBloc bloc});
}

class InScreenChangePwdEvent extends ScreenChangePwdEvent {
  @override
  Stream<ScreenChangePwdState> applyAsync(
      {ScreenChangePwdState currentState, ScreenChangePwdBloc bloc}) async* {
    yield InScreenChangePwdState();
  }
}

class ReauthEvent extends ScreenChangePwdEvent {
  final String email, pwd;

  ReauthEvent(this.email, this.pwd);
  @override
  Stream<ScreenChangePwdState> applyAsync(
      {ScreenChangePwdState currentState, ScreenChangePwdBloc bloc}) async* {
    BaseAuth auth = MyAuth();
    try {
      yield UnScreenChangePwdState();
      FirebaseUser firebaseUser =
          await auth.reAuthenticateWithCredential(email, pwd);
      yield ClearToChangePwdState(firebaseUser);
    } catch (_, stackTrace) {
      if (_ is PlatformException)
        yield ErrorScreenChangePwdState(_?.code);
      else {
        developer.log('$_',
            name: 'LoadScreenChangePwdEvent', error: _, stackTrace: stackTrace);
        yield ErrorScreenChangePwdState(_?.toString());
      }
    }
  }
}

class ChangePwdEvent extends ScreenChangePwdEvent {
  final String pwd;

  ChangePwdEvent(this.pwd);
  @override
  Stream<ScreenChangePwdState> applyAsync(
      {ScreenChangePwdState currentState, ScreenChangePwdBloc bloc}) async* {
    BaseAuth auth = MyAuth();
    try {
      yield UnScreenChangePwdState();
      yield await auth
          .changePassword(pwd)
          .then((value) => ChangePwdSucceedState());
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadScreenChangePwdEvent', error: _, stackTrace: stackTrace);
      yield ErrorScreenChangePwdState(_?.toString());
    }
  }
}

class ForgotPwdEvent extends ScreenChangePwdEvent {
  @override
  Stream<ScreenChangePwdState> applyAsync(
      {ScreenChangePwdState currentState, ScreenChangePwdBloc bloc}) async* {
    yield UnScreenChangePwdState();
    await Future.delayed(Duration(milliseconds: 200));
    yield ForgotPwdState();
  }
}

class SendEmailToResetPwdEvent extends ScreenChangePwdEvent {
  @override
  Stream<ScreenChangePwdState> applyAsync(
      {ScreenChangePwdState currentState, ScreenChangePwdBloc bloc}) async* {
    BaseAuth auth = MyAuth();
    try {
      yield UnScreenChangePwdState();
      yield await auth
          .sendEmailToResetPwd()
          .then((value) => HaveSendEmailToResetPwdState());
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadScreenChangePwdEvent', error: _, stackTrace: stackTrace);
      yield ErrorScreenChangePwdState(_?.toString());
    }
  }
}

class LoadScreenChangePwdEvent extends ScreenChangePwdEvent {
  @override
  Stream<ScreenChangePwdState> applyAsync(
      {ScreenChangePwdState currentState, ScreenChangePwdBloc bloc}) async* {
    try {
      yield UnScreenChangePwdState();
      await Future.delayed(Duration(seconds: 1));
      yield InScreenChangePwdState();
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadScreenChangePwdEvent', error: _, stackTrace: stackTrace);
      yield ErrorScreenChangePwdState(_?.toString());
    }
  }
}
