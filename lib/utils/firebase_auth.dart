import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<FirebaseUser> reAuthenticateWithCredential(String email, String pwd);

  Future<bool> changePassword(String password);

  Future<bool> isEmailVerified();

  Future<bool> sendEmailToResetPwd();
}

class MyAuth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  @override
  Future<FirebaseUser> reAuthenticateWithCredential(
      String email, String pwd) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    var credential =
        EmailAuthProvider.getCredential(email: email, password: pwd);
    AuthResult authResult = await user.reauthenticateWithCredential(credential);
    return authResult.user;
  }

  @override
  Future<bool> changePassword(String password) async {
    //Create an instance of the current user.
    FirebaseUser user = await _firebaseAuth.currentUser();

    //Pass in the password to updatePassword.
    bool result = await user.updatePassword(password).then((_) {
      print("修改密码成功");
      return true;
    }).catchError((error) {
      print("修改密码失败:" + error.toString());
      return false;
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });

    return result;
  }

  @override
  Future<bool> sendEmailToResetPwd() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    bool result = await _firebaseAuth
        .sendPasswordResetEmail(email: user.email)
        .then((value) => true);
    return result;
  }
}
