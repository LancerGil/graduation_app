import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ScreenChangePwdState extends Equatable {
  final List propss;
  ScreenChangePwdState([this.propss]);

  @override
  List<Object> get props => (propss ?? []);
}

/// UnInitialized
class UnScreenChangePwdState extends ScreenChangePwdState {
  UnScreenChangePwdState();

  @override
  String toString() => 'UnScreenChangePwdState';
}

class ClearToChangePwdState extends ScreenChangePwdState {
  final FirebaseUser user;

  ClearToChangePwdState(this.user);

  @override
  String toString() => 'InScreenChangePwdState ${user.email}';
}

class ChangePwdSucceedState extends ScreenChangePwdState {
  ChangePwdSucceedState();
  @override
  String toString() => 'ChangePwdSucceedState';
}

class ForgotPwdState extends ScreenChangePwdState {
  ForgotPwdState();
  @override
  String toString() => 'ForgotPwdState';
}

class HaveSendEmailToResetPwdState extends ScreenChangePwdState {
  HaveSendEmailToResetPwdState();
  @override
  String toString() => 'HaveSendEmailToResetPwdState';
}

/// Initialized
class InScreenChangePwdState extends ScreenChangePwdState {
  InScreenChangePwdState();

  @override
  String toString() => 'InScreenChangePwdState';
}

class ErrorScreenChangePwdState extends ScreenChangePwdState {
  final String errorMessage;

  ErrorScreenChangePwdState(this.errorMessage) : super([errorMessage]);

  @override
  String toString() => 'ErrorScreenChangePwdState';
}
