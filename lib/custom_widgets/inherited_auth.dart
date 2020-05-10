import 'package:flutter/material.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/utils/firebase_auth.dart';

class InheritedAuth extends InheritedWidget {
  final User user;
  final BaseAuth auth;
  final VoidCallback loggoutCallback;

  InheritedAuth({this.user, this.auth, this.loggoutCallback, Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedAuth oldWidget) => oldWidget.auth != auth;

  static InheritedAuth of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedAuth>();
  }
}
